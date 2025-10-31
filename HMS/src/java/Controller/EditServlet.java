package Controller;
import DAO.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import model.User;
import model.Supplier;
import util.PasswordUtils;
import util.LoggingUtil;
/**
 * Servlet for editing users with detailed change tracking and logging
 */
public class EditServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Check session
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        String userRole = (String) session.getAttribute("role");
        if (!"Admin".equals(userRole)) {
            req.setAttribute("errorMessage", "Access denied. This page is for Admins only.");
            req.getRequestDispatcher("error.jsp").forward(req, resp);
            return;
        }
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin-dashboard?error=invalid_id");
            return;
        }
        try {
            int id = Integer.parseInt(idParam);
            User u = userDAO.findById(id);
            if (u == null) {
                resp.sendRedirect(req.getContextPath() + "/admin-dashboard?error=user_not_found");
                return;
            }
            // Load Supplier if role is Supplier
            Supplier supplier = null;
            if ("Supplier".equalsIgnoreCase(u.getRole())) {
                supplier = userDAO.getSupplierByUserId(u.getUserId());
            }
            req.setAttribute("supplier", supplier);
            // Log page view
            LoggingUtil.logView(req, "Edit User Form - " + u.getUsername());
            req.setAttribute("user", u);
            req.getRequestDispatcher("/admin/user_form_edit.jsp").forward(req, resp);
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Check session
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        String userRole = (String) session.getAttribute("role");
        if (!"Admin".equals(userRole)) {
            req.setAttribute("errorMessage", "Access denied. This page is for Admins only.");
            req.getRequestDispatcher("error.jsp").forward(req, resp);
            return;
        }
        try {
            // Get form parameters
            int id = Integer.parseInt(req.getParameter("userId"));
            String username = req.getParameter("username");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String role = req.getParameter("role");
            String companyName = req.getParameter("companyName");
            String address = req.getParameter("address");
            // Get password fields
            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");
            // Get existing user to track changes
            User existingUser = userDAO.findById(id);
            if (existingUser == null) {
                resp.sendRedirect(req.getContextPath() + "/admin-dashboard?error=user_not_found");
                return;
            }
            String oldRole = existingUser.getRole();
            // Get existing supplier if any
            Supplier existingSupplier = null;
            if ("Supplier".equalsIgnoreCase(oldRole)) {
                existingSupplier = userDAO.getSupplierByUserId(id);
            }
            // Validate email uniqueness
            if (email != null && !email.trim().isEmpty()) {
                User emailUser = userDAO.findByEmail(email);
                if (emailUser != null && emailUser.getUserId() != id) {
                    req.setAttribute("error", "Email này đã được sử dụng bởi tài khoản khác!");
                    req.setAttribute("user", existingUser);
                    req.setAttribute("supplier", existingSupplier);
                    req.getRequestDispatcher("/admin/user_form_edit.jsp").forward(req, resp);
                    return;
                }
            }
            // Handle Supplier table updates
            boolean isNewSupplier = "Supplier".equalsIgnoreCase(role) && !"Supplier".equalsIgnoreCase(oldRole);
            boolean isRemovingSupplier = !"Supplier".equalsIgnoreCase(role) && "Supplier".equalsIgnoreCase(oldRole);
            boolean isExistingSupplier = "Supplier".equalsIgnoreCase(role) && "Supplier".equalsIgnoreCase(oldRole);
            // Validate company name if role is Supplier
            if ("Supplier".equalsIgnoreCase(role)) {
                if (companyName == null || companyName.trim().isEmpty()) {
                    req.setAttribute("error", "Tên công ty không được để trống cho vai trò Supplier!");
                    req.setAttribute("user", existingUser);
                    req.setAttribute("supplier", existingSupplier);
                    req.getRequestDispatcher("/admin/user_form_edit.jsp").forward(req, resp);
                    return;
                }
                // Check for duplicate company name
                Supplier duplicateSupplier = userDAO.findSupplierByName(companyName);
                if (duplicateSupplier != null) {
                    if (isNewSupplier || (isExistingSupplier && duplicateSupplier.getSupplierId() != existingSupplier.getSupplierId())) {
                        req.setAttribute("error", "Tên công ty này đã được sử dụng!");
                        req.setAttribute("user", existingUser);
                        req.setAttribute("supplier", existingSupplier);
                        req.getRequestDispatcher("/admin/user_form_edit.jsp").forward(req, resp);
                        return;
                    }
                }
            }
            // Track changes for logging
            StringBuilder changes = new StringBuilder();
            // Check email change
            if (!email.equals(existingUser.getEmail())) {
                changes.append(String.format("Email: '%s' → '%s' | ",
                        existingUser.getEmail(), email));
            }
            // Check phone change
            if (!phone.equals(existingUser.getPhone())) {
                changes.append(String.format("Phone: '%s' → '%s' | ",
                        existingUser.getPhone(), phone));
            }
            // Check role change
            if (!role.equals(oldRole)) {
                changes.append(String.format("Role: '%s' → '%s' | ",
                        oldRole, role));
            }
            // Handle password change if requested
            boolean passwordChanged = false;
            boolean changePassword = newPassword != null && !newPassword.trim().isEmpty();
            if (changePassword) {
                // Validate password
                if (newPassword.length() < 6) {
                    req.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
                    req.setAttribute("user", existingUser);
                    req.setAttribute("supplier", existingSupplier);
                    req.getRequestDispatcher("/admin/user_form_edit.jsp").forward(req, resp);
                    return;
                }
                if (!newPassword.equals(confirmPassword)) {
                    req.setAttribute("error", "Mật khẩu xác nhận không khớp!");
                    req.setAttribute("user", existingUser);
                    req.setAttribute("supplier", existingSupplier);
                    req.getRequestDispatcher("/admin/user_form_edit.jsp").forward(req, resp);
                    return;
                }
                // Hash and update password
                String hashedPassword = PasswordUtils.hash(newPassword);
                userDAO.updatePassword(id, hashedPassword);
                passwordChanged = true;
                // Log password change separately for security
                LoggingUtil.logAction(req, "UPDATE_USER_PASSWORD",
                        String.format("Password changed for user: %s (ID: %d)", username, id));
            }
            // Update basic info
            existingUser.setEmail(email);
            existingUser.setPhone(phone);
            existingUser.setRole(role);
            userDAO.update(existingUser);
            if (isNewSupplier) {
                // Insert new Supplier
                userDAO.insertSupplier(id, companyName, email, phone, address);
                changes.append(String.format("Supplier created: Name='%s', Address='%s' | ", companyName, address));
            } else if (isRemovingSupplier) {
                // Delete Supplier
                userDAO.deleteSupplierByUserId(id);
                changes.append("Supplier record deleted | ");
            } else if (isExistingSupplier) {
                // Update Supplier (sync email, phone, update name, address)
                boolean supplierUpdated = userDAO.updateSupplier(id, companyName, email, phone, address);
                if (supplierUpdated) {
                    // Track supplier changes if needed
                    if (!companyName.equals(existingSupplier.getName())) {
                        changes.append(String.format("Company Name: '%s' → '%s' | ", existingSupplier.getName(), companyName));
                    }
                    if ((existingSupplier.getAddress() == null ? address != null : !existingSupplier.getAddress().equals(address))) {
                        changes.append(String.format("Address: '%s' → '%s' | ", existingSupplier.getAddress(), address));
                    }
                    if (!email.equals(existingSupplier.getContactEmail())) {
                        changes.append(String.format("Contact Email: '%s' → '%s' | ", existingSupplier.getContactEmail(), email));
                    }
                    if (!phone.equals(existingSupplier.getContactPhone())) {
                        changes.append(String.format("Contact Phone: '%s' → '%s' | ", existingSupplier.getContactPhone(), phone));
                    }
                }
            }
            // Log update action with detailed changes
            if (changes.length() > 0 || passwordChanged) {
                String changeLog = changes.length() > 0 ? changes.toString() : "No field changes";
                if (passwordChanged) {
                    changeLog += "Password: CHANGED";
                }
                String detailedLog = String.format(
                        "Updated user: %s (ID: %d) | Changes: %s",
                        username, id, changeLog
                );
                LoggingUtil.logUserUpdate(req, username);
                LoggingUtil.logAction(req, "UPDATE_USER_DETAIL", detailedLog);
            } else {
                // No changes made
                LoggingUtil.logAction(req, "UPDATE_USER_NO_CHANGE",
                        String.format("Accessed update form for user: %s (ID: %d) but made no changes",
                                username, id));
            }
            resp.sendRedirect(req.getContextPath() + "/admin-dashboard?success=updated&user=" + username);
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            // Log error
            LoggingUtil.logAction(req, "UPDATE_USER_FAILED",
                    "Failed to update user | Error: " + e.getMessage());
            throw new ServletException(e);
        }
    }
    @Override
    public String getServletInfo() {
        return "Edit User Servlet with Enhanced Change Tracking and Logging";
    }
}