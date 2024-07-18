<%-- decrementQuantity.jsp --%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="java.util.Map" %>
<%
// Get the session object
HttpSession httpsession = request.getSession();

// Get the productId from the request
int productId = Integer.parseInt(request.getParameter("productId"));

// Get the cart from the session
Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

// Decrement the quantity of the product in the cart
if (cart != null && cart.containsKey(productId)) {
    int quantity = cart.get(productId);
    if (quantity > 1) {
        cart.put(productId, quantity - 1);
    } else {
        cart.remove(productId);
    }
}

// Redirect to the cart page
response.sendRedirect("viewcart.jsp");
%>