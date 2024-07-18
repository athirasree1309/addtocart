<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="dao.ProductDao" %>
<%@ page import="bean.Product" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Shopping Cart</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Bootstrap JS and dependencies -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <div class="container mt-5">
        <h2>Your Shopping Cart</h2>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Item Number</th>
                    <th>Product Name</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Total Price</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // Get the session object
                    HttpSession httpsession = request.getSession();

                    // Get the cart from the session
                    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
                    if (cart == null) {
                        cart = new HashMap<>();
                    }

                    // Get the product IDs from the cart
                    Set<Integer> productIds = cart.keySet();
                    Map<Integer, Product> products = new HashMap<>();
                    if (!productIds.isEmpty()) {
                        try {
                            products = ProductDao.getProductsByIds(productIds);
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }

                    // Initialize item number counter
                    int itemNumber = 1;
                    double totalAmount = 0;
                    for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                        int productId = entry.getKey();
                        int quantity = entry.getValue();
                        Product product = products.get(productId);
                        if (product != null) {
                            double totalPrice = product.getPrice() * quantity;
                            totalAmount += totalPrice;
                %>
                <tr>
                    <td><%= itemNumber %></td>
                    <td><%= product.getName() %></td>
                    <td><%= product.getPrice() %></td>
                    <td><%= quantity %></td>
                    <td><%= totalPrice %></td>
                    <td>
                        <form action="incrementQuantity.jsp" method="post" style="display: inline;">
                            <input type="hidden" name="productId" value="<%= productId %>">
                            <button type="submit" class="btn btn-primary btn-sm">+</button>
                        </form>
                        <form action="decrementQuantity.jsp" method="post" style="display: inline;">
                            <input type="hidden" name="productId" value="<%= productId %>">
                            <button type="submit" class="btn btn-danger btn-sm">-</button>
                        </form>
                    </td>
                </tr>
                <%
                            // Increment item number for the next iteration
                            itemNumber++;
                        }
                    }
                %>
            </tbody>
        </table>
        <div class="text-right">
            <h4>Total Amount: <%= totalAmount %></h4>
        </div>
        
        <!-- Order Summary -->
        <div class="mt-4">
            <h5>Order Summary</h5>
            <ul>
                <li>Total Items: <%= cart.size() %></li>
                <li>Total Amount: <%= totalAmount %></li>
            </ul>
        </div>
        
        <!-- Buy Now Button -->
        <form action="buynow.jsp" method="post">
            <button type="submit" class="btn btn-danger">Buy Now</button>
        </form>
    </div>
</body>
</html>
