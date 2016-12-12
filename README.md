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
  create user without email
  - location
  - weight
  - age
  - sex
  - activity

  ### computed
  - calories
  - nutrients

  from base food list get foods (hardcoded)
  from location lookup prices 
    



2. POST /solver data=computed

3. 







## Backend 

## Views:
 - (a) server-side slime + css + vanilla js
 - (b) server rendered elm + elim-ui



