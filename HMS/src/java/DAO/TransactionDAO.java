package DAO;

import model.Transaction;
import java.sql.*;
import java.util.*;

public class TransactionDAO {

    private Connection connection;

    public TransactionDAO(Connection connection) {
        this.connection = connection;
    }

    // Lấy danh sách giao dịch hết hạn / hư hỏng
    public List<Transaction> getExpiredOrDamaged() throws SQLException {
        List<Transaction> list = new ArrayList<>();
        String sql = """
            SELECT 
                t.transaction_id,
                t.batch_id,
                t.user_id,
                u.username,
                b.lot_number AS lotNumber,
                t.dn_id,
                t.type,
                t.quantity,
                t.transaction_date,
                t.notes,
                m.name AS medicine_name
            FROM Transactions t
            LEFT JOIN Users u ON t.user_id = u.user_id
            LEFT JOIN Batches b ON t.batch_id = b.batch_id
            LEFT JOIN Medicines m ON b.medicine_code = m.medicine_code
            WHERE t.type IN ('Expired', 'Damaged')
            ORDER BY t.transaction_date DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Transaction t = new Transaction();
                t.setTransactionId(rs.getInt("transaction_id"));
                t.setBatchId(rs.getInt("batch_id"));
                t.setUserId(rs.getInt("user_id"));

                // Xử lý dn_id có thể null
                Object dnObj = rs.getObject("dn_id");
                t.setDnId(dnObj != null ? (Integer) dnObj : null);

                t.setType(rs.getString("type"));
                t.setQuantity(rs.getInt("quantity"));
                t.setTransactionDate(rs.getTimestamp("transaction_date"));
                t.setNotes(rs.getString("notes"));
                t.setUsername(rs.getString("username"));
                t.setMedicineName(rs.getString("medicine_name"));
                t.setLotNumber(rs.getString("lotNumber"));
                list.add(t);
            }
        }
        return list;
    }

    // Thêm giao dịch mới
    public void addTransaction(Transaction t) throws SQLException {
        String sql = """
            INSERT INTO Transactions 
                (batch_id, user_id, dn_id, type, quantity, notes)
            VALUES (?, ?, ?, ?, ?, ?)
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, t.getBatchId());
            ps.setInt(2, t.getUserId());
            if (t.getDnId() != null) {
                ps.setInt(3, t.getDnId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setString(4, t.getType());
            ps.setInt(5, t.getQuantity());
            ps.setString(6, t.getNotes());
            ps.executeUpdate();
        }
    }
}
