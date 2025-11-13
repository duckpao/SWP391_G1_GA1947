package Controller;

import DAO.PurchaseOrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.PurchaseOrder;
import model.PurchaseOrderItem;
import java.sql.SQLException;

public class ViewDeliveredOrderDetailsServlet extends HttpServlet {

    private PurchaseOrderDAO dao = new PurchaseOrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String poIdParam = request.getParameter("poId");

        try {
            if (poIdParam == null) {
                // Hiển thị danh sách Delivered Orders
                List<PurchaseOrder> orders = dao.getDeliveredOrders();

                // Tải luôn chi tiết cho mỗi đơn (để JSP có thể dùng collapse)
                for (PurchaseOrder order : orders) {
                    List<PurchaseOrderItem> items = dao.getItemsByPurchaseOrderId(order.getPoId());
                    order.setItems(items);  // cần getter/setter trong model PurchaseOrder
                }

                request.setAttribute("deliveredOrders", orders);
                request.getRequestDispatcher("/pharmacist/ViewDeliveredOrder.jsp")
                       .forward(request, response);

            } else {
                // Nếu muốn vẫn hỗ trợ load riêng chi tiết đơn
                int poId = Integer.parseInt(poIdParam);
                List<PurchaseOrderItem> items = dao.getItemsByPurchaseOrderId(poId);
                request.setAttribute("orderItems", items);
                request.getRequestDispatcher("/pharmacist/ViewDeliveredOrderDetails.jsp")
                       .forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Lỗi khi tải dữ liệu đơn hàng", e);
        }
    }
}
