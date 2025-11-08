package util;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.Random;
import javax.imageio.ImageIO;

public class CaptchaUtil {
    
    private static final Random random = new Random();
    
    /**
     * Tạo một phép tính toán đơn giản (cộng, trừ, nhân)
     * @return String[] {question, answer}
     */
    public static String[] generateMathCaptcha() {
        int num1 = random.nextInt(10) + 1; // 1-10
        int num2 = random.nextInt(10) + 1; // 1-10
        int operation = random.nextInt(3); // 0=+, 1=-, 2=*
        
        String question;
        int answer;
        
        switch (operation) {
            case 0: // Cộng
                question = num1 + " + " + num2 + " = ?";
                answer = num1 + num2;
                break;
            case 1: // Trừ
                // Đảm bảo kết quả >= 0
                if (num1 < num2) {
                    int temp = num1;
                    num1 = num2;
                    num2 = temp;
                }
                question = num1 + " - " + num2 + " = ?";
                answer = num1 - num2;
                break;
            case 2: // Nhân
                num1 = random.nextInt(5) + 1; // 1-5 để dễ tính
                num2 = random.nextInt(5) + 1;
                question = num1 + " × " + num2 + " = ?";
                answer = num1 * num2;
                break;
            default:
                question = num1 + " + " + num2 + " = ?";
                answer = num1 + num2;
        }
        
        return new String[]{question, String.valueOf(answer)};
    }
    
    /**
     * Tạo CAPTCHA image dạng Base64
     * @param text Câu hỏi CAPTCHA
     * @return Base64 encoded image
     */
    public static String generateCaptchaImage(String text) {
        try {
            int width = 250;
            int height = 80;
            
            BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
            Graphics2D g2d = image.createGraphics();
            
            // Anti-aliasing
            g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            g2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
            
            // Background gradient
            GradientPaint gradient = new GradientPaint(0, 0, new Color(240, 248, 255), 
                                                       width, height, new Color(230, 240, 250));
            g2d.setPaint(gradient);
            g2d.fillRect(0, 0, width, height);
            
            // Border
            g2d.setColor(new Color(108, 117, 125));
            g2d.setStroke(new BasicStroke(3));
            g2d.drawRect(2, 2, width - 4, height - 4);
            
            // Add noise lines
            g2d.setStroke(new BasicStroke(1.5f));
            for (int i = 0; i < 8; i++) {
                g2d.setColor(new Color(random.nextInt(100) + 150, 
                                      random.nextInt(100) + 150, 
                                      random.nextInt(100) + 150, 100));
                int x1 = random.nextInt(width);
                int y1 = random.nextInt(height);
                int x2 = random.nextInt(width);
                int y2 = random.nextInt(height);
                g2d.drawLine(x1, y1, x2, y2);
            }
            
            // Add dots
            for (int i = 0; i < 50; i++) {
                g2d.setColor(new Color(random.nextInt(100) + 150, 
                                      random.nextInt(100) + 150, 
                                      random.nextInt(100) + 150, 150));
                int x = random.nextInt(width);
                int y = random.nextInt(height);
                g2d.fillOval(x, y, 3, 3);
            }
            
            // Draw text
            g2d.setFont(new Font("Arial", Font.BOLD, 32));
            FontMetrics fm = g2d.getFontMetrics();
            int textWidth = fm.stringWidth(text);
            int x = (width - textWidth) / 2;
            int y = (height + fm.getAscent()) / 2 - 5;
            
            // Shadow
            g2d.setColor(new Color(0, 0, 0, 50));
            g2d.drawString(text, x + 2, y + 2);
            
            // Main text
            g2d.setColor(new Color(52, 58, 64));
            g2d.drawString(text, x, y);
            
            g2d.dispose();
            
            // Convert to Base64
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(image, "png", baos);
            byte[] imageBytes = baos.toByteArray();
            return Base64.getEncoder().encodeToString(imageBytes);
            
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Verify CAPTCHA answer
     * @param userAnswer Câu trả lời của user
     * @param correctAnswer Đáp án đúng
     * @return true nếu đúng
     */
    public static boolean verifyCaptcha(String userAnswer, String correctAnswer) {
        if (userAnswer == null || correctAnswer == null) {
            return false;
        }
        return userAnswer.trim().equals(correctAnswer.trim());
    }
}