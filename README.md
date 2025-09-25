# piktochart_acme

Assumptions:

1. The currency conversion is static, no external APIs are called to find the dynamic rates.
2. All the prices are stable during the checkout flow, price updates during the checkout session are not accounted for as in real system would. 
3. Shipping is calculated after the discount but before taxes (which are not implemented in it).
4. Race conditions around cart updates are not accounted for yet, in production cart should be stored in database with some lock mechanism.
5. Idempotency is not taken care for yet, request for double checkout of same order is not taken care of right now.
6. I assume all SKUs exist in the catalogue, in production more errors can be added.
7. This code is safe for single-threaded demo and local testing, but not thread-safe for concurrent modifications.
8. You can use more than one discount rule at the same time. If two rules apply to the same product, they will both be applied together. This is intentional, but the business team should confirm whether that’s the right behavior.


How does it works

1. Products & Catalogue
- Each product has a sku, name, price, and currency.
- Catalogue holds all available products and lets the cart look them up.

2. Cart
- Items are added using cart.add(sku, qty) creates or increments CartItem.
- Subtotal: sum of all product prices × quantities.
- Discounts: total from applied discount rules.
- Shipping: calculated based on subtotal – discounts.
- Total: (subtotal - discounts + shipping).truncate(2)
- total_in_currency: converts the total using CurrencyConverter.

3. Discount Rule
- BuyOneGetSecondHalfPrice: For every pair of the same item, the second is half price.

4. Shipping Rule
- TieredShippingRule:
```
≥ $90 → Free
≥ $50 → $2.95
Else → $4.95
```

5. Checkout
Wraps the cart.
scan(sku, qty) adds items to the cart.
total(currency:) returns the total, optionally converted.

Example usage can be found in top_level_usage in root directory. 