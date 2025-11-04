<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Hospital Pharmacy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .error-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .error-card {
            max-width: 600px;
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        .error-icon {
            font-size: 5rem;
            color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card error-card">
                        <div class="card-body text-center p-5">
                            <i class="bi bi-exclamation-triangle error-icon"></i>
                            
                            <h1 class="display-4 mt-3">Oops!</h1>
                            
                            <c:choose>
                                <c:when test="${not empty errorMessage}">
                                    <p class="lead text-muted mb-4">${errorMessage}</p>
                                </c:when>
                                <c:when test="${pageContext.errorData != null}">
                                    <p class="lead text-muted mb-4">
                                        Error ${pageContext.errorData.statusCode}: 
                                        ${pageContext.errorData.throwable != null ? 
                                          pageContext.errorData.throwable.message : 
                                          'An unexpected error occurred'}
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <p class="lead text-muted mb-4">
                                        An unexpected error occurred. Please try again later.
                                    </p>
                                </c:otherwise>
                            </c:choose>
                            
                            <hr class="my-4">
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-center">
                                <a href="javascript:history.back()" class="btn btn-secondary btn-lg">
                                    <i class="bi bi-arrow-left"></i> Go Back
                                </a>
                                <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-lg">
                                    <i class="bi bi-house"></i> Home
                                </a>
                            </div>
                            
                            <c:if test="${pageContext.request.userPrincipal != null}">
                                <div class="mt-4">
                                    <small class="text-muted">
                                        If the problem persists, please contact the system administrator.
                                    </small>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>