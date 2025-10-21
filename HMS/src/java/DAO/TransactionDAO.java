package DAO;

import model.Transaction;
import java.sql.*;
import java.util.*;

public class TransactionDAO {

    private DBContext dbContext = new DBContext();

    // ✅ Ghi nhận một transaction mới (ví dụ: Expired / Damaged)
    public boolean insertTransaction(Transaction t) {
        String sql = """
            INSERT INTO Transactions (batch_id, user_id, dn_id, type, quantity, transaction_date, notes)
            VALUES (?, ?, ?, ?, ?, GETDATE(), ?)
        """;

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Lấy danh sách tất cả các transaction (dùng cho audit hoặc history)
    public List<Transaction> getAllTransactions() {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT * FROM Transactions ORDER BY transaction_date DESC";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Transaction t = new Transaction();
                t.setTransactionId(rs.getInt("transaction_id"));
                t.setBatchId(rs.getInt("batch_id"));
                t.setUserId(rs.getInt("user_id"));
                t.setDnId((Integer) rs.getObject("dn_id"));
                t.setType(rs.getString("type"));
                t.setQuantity(rs.getInt("quantity"));
                t.setTransactionDate(rs.getTimestamp("transaction_date"));
                t.setNotes(rs.getString("notes"));
                list.add(t);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // ✅ Lấy danh sách transaction theo batch_id (xem lịch sử 1 lô thuốc)
    public List<Transaction> getTransactionsByBatchId(int batchId) {
        List<Transaction> list = new ArrayList<>();
        String sql = "SELECT * FROM Transactions WHERE batch_id = ? ORDER BY transaction_date DESC";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, batchId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Transaction t = new Transaction();
                    t.setTransactionId(rs.getInt("transaction_id"));
                    t.setBatchId(rs.getInt("batch_id"));
                    t.setUserId(rs.getInt("user_id"));
                    t.setDnId((Integer) rs.getObject("dn_id"));
                    t.setType(rs.getString("type"));
                    t.setQuantity(rs.getInt("quantity"));
                    t.setTransactionDate(rs.getTimestamp("transaction_date"));
                    t.setNotes(rs.getString("notes"));
                    list.add(t);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // ✅ Xóa 1 transaction (nếu cần thiết)
    public boolean deleteTransaction(int transactionId) {
        String sql = "DELETE FROM Transactions WHERE transaction_id = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, transactionId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
