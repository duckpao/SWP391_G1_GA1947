package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.CaptchaUtil;
import java.io.IOException;
import java.io.PrintWriter;

public class CaptchaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Generate new CAPTCHA
        String[] captcha = CaptchaUtil.generateMathCaptcha();
        String question = captcha[0];
        String answer = captcha[1];
        
        // Save answer to session
        HttpSession session = request.getSession();
        session.setAttribute("captchaAnswer", answer);
        session.setAttribute("captchaGenTime", System.currentTimeMillis());
        
        // Generate image
        String base64Image = CaptchaUtil.generateCaptchaImage(question);
        
        // Return JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        out.print("{");
        out.print("\"success\": true,");
        out.print("\"image\": \"data:image/png;base64," + base64Image + "\"");
        out.print("}");
        out.flush();
    }
}