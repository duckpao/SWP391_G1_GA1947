package model;

import java.sql.Date;

public class Task {
    private int taskId;
    private int poId;
    private int staffId;
    private String taskType;
    private Date deadline;
    private String status;
    private Date createdAt;
    private Date updatedAt;
    private String staffName; // Để hiển thị tên nhân viên
    private String poNotes;   // Để hiển thị ghi chú của Purchase Order

    // Constructors
    public Task() {
    }

    public Task(int poId, int staffId, String taskType, Date deadline, String status) {
        this.poId = poId;
        this.staffId = staffId;
        this.taskType = taskType;
        this.deadline = deadline;
        this.status = status;
    }

    // Getters and Setters
    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    public int getPoId() {
        return poId;
    }

    public void setPoId(int poId) {
        this.poId = poId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getTaskType() {
        return taskType;
    }

    public void setTaskType(String taskType) {
        this.taskType = taskType;
    }

    public Date getDeadline() {
        return deadline;
    }

    public void setDeadline(Date deadline) {
        this.deadline = deadline;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public String getPoNotes() {
        return poNotes;
    }

    public void setPoNotes(String poNotes) {
        this.poNotes = poNotes;
    }

    @Override
    public String toString() {
        return "Task{" +
                "taskId=" + taskId +
                ", poId=" + poId +
                ", staffId=" + staffId +
                ", taskType='" + taskType + '\'' +
                ", deadline=" + deadline +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                ", staffName='" + staffName + '\'' +
                ", poNotes='" + poNotes + '\'' +
                '}';
    }
}