class InvoiceItem{
 final String title;
 final int quantity;
 final double price;
 final double percentage;
 late final double subtotal;

  InvoiceItem(
      {required this.title, required this.quantity, required this.price, required this.percentage, required this.subtotal});
}