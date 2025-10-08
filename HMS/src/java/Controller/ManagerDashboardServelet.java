package Controller;

import model.Supplier;
import DAO.SupplierDAO;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Manager Dashboard Servlet - Manager có toàn quyền quản lý Supplier
 * Các chức năng: View, Add, Edit, Delete, Filter Suppliers
 */
@WebServlet(name = "ManagerDashboardServlet", urlPatterns = {"/manager/dashboard"})
public class ManagerDashboardServlet extends HttpServlet {
    
    // Database configuration
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=SWP391";
    private static final String DB_USER = "your_username";
    private static final String DB_PASSWORD = "your_password";
    
    /**
     * Lấy kết nối database
     */
    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
    
    /**
     * Kiểm tra quyền Manager
     */
    private boolean isManager(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        
        String role = (String) session.getAttribute("role");
        if (!"manager".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/unauthorized");
            return false;
        }
        
        return true;
    }
    
    /**
     * Xử lý GET request - Hiển thị danh sách suppliers
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra quyền Manager
        if (!isManager(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        
        try (Connection conn = getConnection()) {
            SupplierDAO supplierDAO = new SupplierDAO(conn);
            
            switch (action != null ? action : "list") {
                case "list":
                    listSuppliers(request, response, supplierDAO);
                    break;
                    
                case "view":
                    viewSupplier(request, response, supplierDAO);
                    break;
                    
                case "add":
                    request.getRequestDispatcher("/WEB-INF/views/manager/addSupplier.jsp")
                           .forward(request, response);
                    break;
                    
                case "edit":
                    editSupplierForm(request, response, supplierDAO);
                    break;
                    
                case "delete":
                    deleteSupplier(request, response, supplierDAO);
                    break;
                    
                case "filter":
                    filterSuppliers(request, response, supplierDAO);
                    break;
                    
                default:
                    listSuppliers(request, response, supplierDAO);
                    break;
            }
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi kết nối database: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Xử lý POST request - Thêm, sửa supplier
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra quyền Manager
        if (!isManager(request, response)) {
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        try (Connection conn = getConnection()) {
            SupplierDAO supplierDAO = new SupplierDAO(conn);
            
            switch (action != null ? action : "") {
                case "add":
                    addSupplier(request, response, supplierDAO);
                    break;
                    
                case "update":
                    updateSupplier(request, response, supplierDAO);
                    break;
                    
                default:
                    response.sendRedirect(request.getContextPath() + "/manager/dashboard");
                    break;
            }
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị danh sách tất cả suppliers
     */
    private void listSuppliers(HttpServletRequest request, HttpServletResponse response,
                               SupplierDAO supplierDAO) throws ServletException, IOException {
        List<Supplier> suppliers = supplierDAO.getAllSuppliers();
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("totalSuppliers", suppliers.size());
        request.getRequestDispatcher("/WEB-INF/views/manager/supplierList.jsp")
               .forward(request, response);
    }
    
    /**
     * Xem chi tiết một supplier
     */
    private void viewSupplier(HttpServletRequest request, HttpServletResponse response,
                             SupplierDAO supplierDAO) throws ServletException, IOException {
        int supplierId = Integer.parseInt(request.getParameter("id"));
        Supplier supplier = supplierDAO.getSupplierById(supplierId);
        
        if (supplier != null) {
            request.setAttribute("supplier", supplier);
            request.getRequestDispatcher("/WEB-INF/views/manager/viewSupplier.jsp")
                   .forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Không tìm thấy supplier với ID: " + supplierId);
            listSuppliers(request, response, supplierDAO);
        }
    }
    
    /**
     * Hiển thị form chỉnh sửa supplier
     */
    private void editSupplierForm(HttpServletRequest request, HttpServletResponse response,
                                  SupplierDAO supplierDAO) throws ServletException, IOException {
        int supplierId = Integer.parseInt(request.getParameter("id"));
        Supplier supplier = supplierDAO.getSupplierById(supplierId);
        
        if (supplier != null) {
            request.setAttribute("supplier", supplier);
            request.getRequestDispatcher("/WEB-INF/views/manager/editSupplier.jsp")
                   .forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Không tìm thấy supplier với ID: " + supplierId);
            listSuppliers(request, response, supplierDAO);
        }
    }
    
    /**
     * Thêm supplier mới
     */
    private void addSupplier(HttpServletRequest request, HttpServletResponse response,
                            SupplierDAO supplierDAO) throws ServletException, IOException {
        // Lấy thông tin từ form
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String ratingStr = request.getParameter("rating");
        
        // Tạo supplier mới
        Supplier supplier = new Supplier();
        supplier.setName(name);
        supplier.setContactEmail(email);
        supplier.setContactPhone(phone);
        supplier.setAddress(address);
        
        if (ratingStr != null && !ratingStr.isEmpty()) {
            supplier.setPerformanceRating(Double.parseDouble(ratingStr));
        }
        
        supplier.setCreatedAt(LocalDateTime.now());
        supplier.setUpdatedAt(LocalDateTime.now());
        
        // Thêm vào database
        int newId = supplierDAO.addSupplier(supplier);
        
        if (newId > 0) {
            request.getSession().setAttribute("successMessage", 
                "Thêm supplier thành công! ID: " + newId);
            response.sendRedirect(request.getContextPath() + "/manager/dashboard?action=list");
        } else {
            request.setAttribute("errorMessage", "Không thể thêm supplier!");
            request.setAttribute("supplier", supplier);
            request.getRequestDispatcher("/WEB-INF/views/manager/addSupplier.jsp")
                   .forward(request, response);
        }
    }
    
    /**
     * Cập nhật thông tin supplier
     */
    private void updateSupplier(HttpServletRequest request, HttpServletResponse response,
                               SupplierDAO supplierDAO) throws ServletException, IOException {
        // Lấy thông tin từ form
        int supplierId = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String ratingStr = request.getParameter("rating");
        
        // Lấy supplier hiện tại
        Supplier supplier = supplierDAO.getSupplierById(supplierId);
        
        if (supplier != null) {
            // Cập nhật thông tin
            supplier.setName(name);
            supplier.setContactEmail(email);
            supplier.setContactPhone(phone);
            supplier.setAddress(address);
            
            if (ratingStr != null && !ratingStr.isEmpty()) {
                supplier.setPerformanceRating(Double.parseDouble(ratingStr));
            }
            
            supplier.setUpdatedAt(LocalDateTime.now());
            
            // Cập nhật database
            boolean success = supplierDAO.updateSupplier(supplier);
            
            if (success) {
                request.getSession().setAttribute("successMessage", 
                    "Cập nhật supplier thành công!");
                response.sendRedirect(request.getContextPath() + 
                    "/manager/dashboard?action=view&id=" + supplierId);
            } else {
                request.setAttribute("errorMessage", "Không thể cập nhật supplier!");
                request.setAttribute("supplier", supplier);
                request.getRequestDispatcher("/WEB-INF/views/manager/editSupplier.jsp")
                       .forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Không tìm thấy supplier!");
            response.sendRedirect(request.getContextPath() + "/manager/dashboard?action=list");
        }
    }
    
    /**
     * Xóa supplier
     */
    private void deleteSupplier(HttpServletRequest request, HttpServletResponse response,
                               SupplierDAO supplierDAO) throws ServletException, IOException {
        int supplierId = Integer.parseInt(request.getParameter("id"));
        boolean success = supplierDAO.deleteSupplier(supplierId);
        
        if (success) {
            request.getSession().setAttribute("successMessage", 
                "Xóa supplier thành công!");
        } else {
            request.getSession().setAttribute("errorMessage", 
                "Không thể xóa supplier! Có thể supplier đang được sử dụng.");
        }
        
        response.sendRedirect(request.getContextPath() + "/manager/dashboard?action=list");
    }
    
    /**
     * Lọc suppliers theo tiêu chí
     */
    private void filterSuppliers(HttpServletRequest request, HttpServletResponse response,
                                SupplierDAO supplierDAO) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String minRatingStr = request.getParameter("minRating");
        String maxRatingStr = request.getParameter("maxRating");
        
        Double minRating = (minRatingStr != null && !minRatingStr.isEmpty()) 
                          ? Double.parseDouble(minRatingStr) : null;
        Double maxRating = (maxRatingStr != null && !maxRatingStr.isEmpty()) 
                          ? Double.parseDouble(maxRatingStr) : null;
        
        List<Supplier> suppliers = supplierDAO.filterSuppliers(name, minRating, maxRating, 
                                                               email, phone);
        
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("totalSuppliers", suppliers.size());
        request.setAttribute("filterApplied", true);
        request.getRequestDispatcher("/WEB-INF/views/manager/supplierList.jsp")
               .forward(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Manager Dashboard Servlet - Quản lý Suppliers";
    }
}