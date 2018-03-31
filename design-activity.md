What classes does each implementation include? Are the lists the same?
Both implementations have the same classes, which are:
- CartEntry:
    @unitprice
    @quantity
- ShoppingCart
    @entries
- Order
    @cart
And each class stores the same data.
So the state of each one is the same, the big difference is their behaviour.
In the two different implementations same classes do different things.



Write down a sentence to describe each class.

Implementation A
- CartEntry : Stores a price with the quantity of that price.
- ShoppingCart : Stores a list of the CartEntry instances.
- Order : Has the shopping cart instance, that has the list of every CartEntry. With that data it calculates the total price of each cart entry, then sums the list of entries of the shopping cart and adds the tax, so it gets the total fo the order.

Implementation B
- CartEntry : Stores a price with the quantity of that price and it is able to caclulate the total price of that cart entry.
- ShoppingCart : It stores the list of each cart entry with their own price. And it is able to add all the prices and get a subtotal.
- Order : It gets one instance of a ShoppingCart and it calculates the tax for it and adds it to the price.




How do the classes relate to each other? It might be helpful to draw a diagram on a whiteboard or piece of paper.
Implementation A :  ShoppingCart stores instances of CartEntry and then Order gets the instance of shopping cart and calculates the price of each entry.

Impleamentation B: ShoppingCart gets the price of every CartEntry and adds them to get the price of the shopping cart. then the order gets an instance of ShoppingCart and calculates the tax of it.




What data does each class store? How (if at all) does this differ between the two implementations?
Both classes store the same data but each piece of data has different things in it.
In implementation A, the data stored is not manipulated until if gets to Order, which is the "higher class" that does all the work.
In implementation B: The data stored in each class has some behaviour so each class does something with the data-



What methods does each class have? How (if at all) does this differ between the two implementations?
Implementation A
- CartEntry:

- ShoppingCart

- Order
    method : total_price

Implementation B
- CartEntry:
    method: price
- ShoppingCart
    method: price
- Order
    method: total_price

    It differs because in implementation B each class has its own state and behaviour, so they have their own responsability.
     In implementation B the Order class does all the work.


Consider the Order#total_price method. In each implementation:
Is logic to compute the price delegated to "lower level" classes like ShoppingCart and CartEntry, or is it retained in Order?
Implementation A: it is retained in Order.
Implementation B: it is delegated into the "lower level" classes.

Does total_price directly manipulate the instance variables of other classes?
Implementation A: It does
Implementation B: It does not.


If we decide items are cheaper if bought in bulk, how would this change the code? Which implementation is easier to modify?
Implementation B: Because we can modify the price of it in the method total in CartEntry if the quantity is more that x. The others do not really care about that change.

Which implementation better adheres to the single responsibility principle?
Implementation B.



Bonus question once you've read Metz ch. 3: Which implementation is more loosely coupled?
