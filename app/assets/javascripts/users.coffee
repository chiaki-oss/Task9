# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
 $("#user_postal_code").jpostal({
  postcode:["#user_postal_code"],

  address:{
   "#user_prefecture_code":"%3",
   "#user_address_city":"%4%5",
   "#user_address_street":"%6%7"
  }
 })


#postal_code 000-0000の場合、
#postcode:['#zipcode1','#zipcode2']

#form_items
# %3 prefecture / %4 city / %5 townarea / %6 address number / %7 building name