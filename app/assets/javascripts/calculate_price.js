var calculate_price = function(){
  var price = 10
  var weight = document.getElementById('parcel_weight').value
  var height = document.getElementById('parcel_height').value
  var width = document.getElementById('parcel_width').value
  var depth = document.getElementById('parcel_depth').value
  var dimension_weight = (height * width * depth) / 6000
  price += Math.max(weight, dimension_weight)
  price_rounded = round(price, 1)
  document.getElementById('calculated-price').innerHTML = price_rounded + ' zł'
}

function round(value, decimals) {
  return Number(Math.round(value+'e'+decimals)+'e-'+decimals);
}
