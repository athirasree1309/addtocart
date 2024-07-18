<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
try {
    // Get the session object
    HttpSession httpsession = request.getSession();

    // Get the productId from the request
    String productIdStr = request.getParameter("id");
    if (productIdStr == null || productIdStr.isEmpty()) {
        throw new NumberFormatException("Product ID is missing");
    }
    int productId = Integer.parseInt(productIdStr);

    // Get the cart from the session, create a new cart if it doesn't exist
    Map<Integer, Integer> cart = (Map<Integer, Integer>) httpsession.getAttribute("cart");
    if (cart == null) {
        cart = new HashMap<>();
        httpsession.setAttribute("cart", cart);
    }

    // Add the product to the cart or update the quantity if it already exists
    cart.put(productId, cart.getOrDefault(productId, 0) + 1);

    // Redirect to the cart page
    response.sendRedirect("viewcart.jsp");
} catch (NumberFormatException e) {
    // Handle potential NumberFormatException if productId is not a valid integer
    response.sendRedirect("error.jsp?message=Invalid%20product%20ID");
}
%>
