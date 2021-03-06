
package.path = package.path .. ";./../../../?.lua"
Luna = require("Luna/luna")
Luna.introduce()

local Account = class {

  --[[
    The class' constructor. Whenever a new instance of
    a class is created, its 'constructor' function is
    immediately called. The 'self' argument is the
    instance of the class.

    Any arguments besides `self` are provided from the
    varargs to the `constructor` call. For example,
    invoking
        new(Account, 100)
    will create a new instance of the `Account` class
    and call the instance's constructor, passing the
    instance as well as the value `100` as arguments.
  ]]
  constructor = function(self, balance)
    -- By convention, prefix hidden variables with two
    -- underscores '__' so developers know not to use
    -- them!
    self.__balance = balance
  end,

  --[[
    Adds the specified amount of money to this `Account`'s
    balance.
  ]]
  deposit = function(self, amount)
    self.__balance = self.__balance + amount
  end,

  --[[
    Subtracts the specified amount of money from this
    `Account`'s balance and returns it.
  ]]
  withdraw = function(self, amount)
    if (amount > self.__balance) then
      print("You cannot withdraw more money than you have!")
      print("(You have $" .. self.__balance .. ")")
      return 0
    end
    self.__balance = self.__balance - amount
    return amount
  end,

  --[[
    Returns this `Account`'s balance.
  ]]
  getBalance = function(self)
    return self.__balance
  end

}

-- Here we create a new instance of the `Account`
-- class and give it an initial balance of 50.
local my_account = new(Account, 50)

--[[
  When we want to invoke an instance's function,
  we have to use a colon (':') instead of a period
  ('.'). This is syntactic sugar and causes Lua to
  automatically pass the instance as the first
  parameter to the function call.

  For example, the code
      my_instance:my_function(1, 2, 3)
  is exactly the same as the code
      my_instance.my_function(my_instance, 1, 2, 3)

]]
print("Your current balance is $" .. my_account:getBalance() .. "!")

my_account:deposit(100)
print("\tDeposited $100")
my_account:withdraw(10)
print("\tWithdrew $10")
print("\nYour new balance is $" .. my_account:getBalance() .. "!")
