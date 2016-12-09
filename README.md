# Food

## User details
 - id
 - name
 - age
 - weight
 - activity level
 - sex

## user_foods
  - user_id
  - food_id

## prices
  - user_id
  - food_id
  - food name
  - date
    
 - 

## Food
  - NZFF_id
  - USDA_id
  - category
  - nutrient a 
  - nutrient b
  ...
## User foods
 - food_id

## Receipts
 - id
 - store_receipt_id
 - company_id
 - store_id
 - user_id
 - image_url

 ## price_record
  - receipt_id
  - store_product_id
  - description
  - price: float
  - measure: string
  - quantity: float
  - extended_price: float
  - sales_tax_inclusive: boolean
  - date_time
  - created_at

## stores
  - id
  - latitude
  - longitude


## Flows

**Unauthenticated user**
1. Set diet parameters:
  - vegetarian
  - vegan
  - sex
  - age
  - weight
  - **location**

2. Submit: "My shopping list"

3. See weekly shopping list:
  - minimum price
  - micronutrient sufficiency
  - [n3:n6 ratio]

**Implementation**

1. Associate diet parameters w/ new user
  create user [-email, -name]

2. POST /solver data=parameters 

solver Find prices by location

define function constraints:

fun  nutrient_sufficiency(qty, reccomended):
    if qty > reccomended 
      return 1
    else 
      return qty / reccomended

def foods [
  food:
    price: <- set price from user location
    qty: Float
    nutrientA: Float
    ...
  ..
]

def nutrientMap
  nutrient: 
    - qty
    - reccomended
    - score

fun calculateCostandSufficiency(foods, nutrientMap):
  def scores = []
  let cost = 0

  for food in foods
    cost += food.price * food.qty
    for nutrient in food
      nutrientMap[nutrient].qty += food[nutrient]
    end
  end

  for nutrient in nutrientMap
    let score = nutrient_sufficiency(nutrient.qty, nutrient.reccomended)
    nutrient.score = score
    scores.append(score)
  end

  let sufficiency = average(scores)

end

minin











## Backend 

## Views:
 - (a) server-side slime + css + vanilla js
 - (b) server rendered elm + elim-ui



