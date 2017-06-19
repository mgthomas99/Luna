
local Account = {}
Account.__index = Account

function Account:new(name, balance)
  local acc = setmetatable({}, self)
  acc.name = name
  acc.balance = balance
  return acc
end

function Account:deposit(amount)
  self.balance = self.balance + amount
end

function Account:withdraw(amount)
  if (amount > self.balance) then
    print("You do not have enough money!")
    return 0
  end
  self.balance = self.balance - amount
  return amount
end

local account1 = Account:new("Foo", 50)
local account2 = Account:new("Ray", 30)
account1:deposit( account2:withdraw(10) )

print(account1.name .. " has $" .. account1.balance)
print(account2.name .. " has $" .. account2.balance)
