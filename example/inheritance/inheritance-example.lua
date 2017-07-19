
package.path = package.path .. ";./../../../?.lua"
Luna = require("Luna/luna")
Luna.introduce()

local Animal = class({
  constructor = function(self)
  end,

  get_leg_count = function(self)
    return 4
  end,

  make_noise = function(self)
    print("Abstract animal has no noise!")
  end
})

local Cat = class(Animal, {
  constructor = function(self) end,

  make_noise = function(self)
    return "Meow!"
  end
})

local Dog = class(Animal, {
  constructor = function(self) end,

  make_noise = function(self)
    return "Woof!"
  end
})

local my_cat = new(Cat)
local my_dog = new(Dog)

print("Cat says \"" .. my_cat:make_noise() .. "\"")
print("Cat has " .. my_cat:get_leg_count() .. " legs")
print("Dog says \"" .. my_dog:make_noise() .. "\"")
print("Dog has " .. my_dog:get_leg_count() .. " legs")
