package Controller;

import DAO.SupplierDAO;
import model.Supplier;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class SupplierServlet extends HttpServlet {
    private  SupplierDAO supplierDAO = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        PrintWriter out = resp.getWriter();
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            if (action != null) {
                switch (action) {
                    case "getById":
                        int id = Integer.parseInt(req.getParameter("id"));
                        Optional<Supplier> supplier = supplierDAO.getSupplierById(id);
                        if (supplier.isPresent()) {
                            out.print(convertSupplierToJson(supplier.get()));
                        } else {
                            out.print("{\"error\": \"Supplier not found\"}");
                        }
                        break;
                    case "getAll":
                        List<Supplier> suppliers = supplierDAO.getAllSuppliers();
                        out.print(convertSuppliersToJson(suppliers));
                        break;
                    case "searchByName":
                        String name = req.getParameter("name");
                        List<Supplier> foundSuppliers = supplierDAO.findSuppliersByName(name);
                        out.print(convertSuppliersToJson(foundSuppliers));
                        break;
                    default:
                        out.print("{\"error\": \"Invalid action\"}");
                }
            } else {
                // Default: get all suppliers
                List<Supplier> suppliers = supplierDAO.getAllSuppliers();
                out.print(convertSuppliersToJson(suppliers));
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        PrintWriter out = resp.getWriter();
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            if ("add".equals(action)) {
                Supplier supplier = new Supplier();
                supplier.setName(req.getParameter("name"));
                supplier.setContactEmail(req.getParameter("contactEmail"));
                supplier.setContactPhone(req.getParameter("contactPhone"));
                supplier.setAddress(req.getParameter("address"));
                
                String ratingParam = req.getParameter("performanceRating");
                if (ratingParam != null && !ratingParam.isEmpty()) {
                    supplier.setPerformanceRating(Double.parseDouble(ratingParam));
                }
                
                boolean success = supplierDAO.addSupplier(supplier);
                if (success) {
                    out.print("{\"message\": \"Supplier added successfully\", \"id\": " + supplier.getSupplierId() + "}");
                } else {
                    out.print("{\"error\": \"Failed to add supplier\"}");
                }
            } else {
                out.print("{\"error\": \"Invalid action\"}");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "PUT method not supported in this implementation");
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        PrintWriter out = resp.getWriter();
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                boolean success = supplierDAO.deleteSupplier(id);
                if (success) {
                    out.print("{\"message\": \"Supplier deleted successfully\"}");
                } else {
                    out.print("{\"error\": \"Failed to delete supplier\"}");
                }
            } else {
                out.print("{\"error\": \"Invalid action\"}");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    // Helper methods to convert to JSON manually (without Jackson)
    private String convertSupplierToJson(Supplier supplier) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"supplierId\":").append(supplier.getSupplierId()).append(",");
        json.append("\"name\":\"").append(escapeJson(supplier.getName())).append("\",");
        json.append("\"contactEmail\":\"").append(escapeJson(supplier.getContactEmail())).append("\",");
        json.append("\"contactPhone\":\"").append(escapeJson(supplier.getContactPhone())).append("\",");
        json.append("\"address\":\"").append(escapeJson(supplier.getAddress())).append("\",");
        
        if (supplier.getPerformanceRating() != null) {
            json.append("\"performanceRating\":").append(supplier.getPerformanceRating()).append(",");
        } else {
            json.append("\"performanceRating\":null,");
        }
        
        if (supplier.getCreatedAt() != null) {
            json.append("\"createdAt\":\"").append(supplier.getCreatedAt()).append("\",");
        }
        
        if (supplier.getUpdatedAt() != null) {
            json.append("\"updatedAt\":\"").append(supplier.getUpdatedAt()).append("\"");
        } else {
            // Remove trailing comma if no updatedAt
            json.deleteCharAt(json.length() - 1);
        }
        
        json.append("}");
        return json.toString();
    }

    private String convertSuppliersToJson(List<Supplier> suppliers) {
        StringBuilder json = new StringBuilder();
        json.append("[");
        for (int i = 0; i < suppliers.size(); i++) {
            json.append(convertSupplierToJson(suppliers.get(i)));
            if (i < suppliers.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");
        return json.toString();
    }

    private String escapeJson(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\b", "\\b")
                   .replace("\f", "\\f")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}