# UTF-8

require 'mysql'

class IngreMatch
  myIngredientPortion = 'English Muffin'
  myNumber = %w{57.00 12.00 14.15 15.21}
  myNumber.each do |xx|
    puts @y = xx
  end

  con = Mysql.new('10.10.13.1', 'root', 'openface', 'bk_com_us_mdm_2')
  rs = con.query("SELECT * FROM drupal_node WHERE title LIKE '%#{myIngredientPortion}%'")
  rs.each_hash do |h|
    puts "Ingredient: #{h['title']} ## nid: #{h['nid']}"

    rs2 = con.query("(SELECT 'field_weight_value' AS b , field_weight_value AS a FROM drupal_field_data_field_weight WHERE entity_id = '#{h['nid']}') UNION (SELECT 'field_calories_value' AS b, field_calories_value AS a FROM drupal_field_data_field_calories WHERE entity_id = '#{h['nid']}') UNION (SELECT 'field_protein_value' AS b, field_protein_value AS a FROM drupal_field_data_field_protein WHERE entity_id = '#{h['nid']}') UNION (SELECT 'field_carbohydrates_value' AS b , field_carbohydrates_value AS a FROM drupal_field_data_field_carbohydrates WHERE entity_id = '#{h['nid']}') UNION (SELECT 'field_sugar_value' AS b, field_sugar_value AS a FROM drupal_field_data_field_sugar WHERE entity_id = '#{h['nid']}') UNION (SELECT 'field_fat_value' AS b, field_fat_value AS a FROM drupal_field_data_field_fat WHERE entity_id = '#{h['nid']}') UNION (SELECT 'field_saturated_fat_value' AS b , field_saturated_fat_value AS a FROM drupal_field_data_field_saturated_fat WHERE entity_id = '#{h['nid']}') UNION (SELECT 'field_trans_fat_value' AS b, field_trans_fat_value AS a FROM drupal_field_data_field_trans_fat WHERE entity_id = '#{h['nid']}') UNION (SELECT 'field_cholesterol_value' AS b, field_cholesterol_value AS a FROM drupal_field_data_field_cholesterol WHERE entity_id = '#{h['nid']}') UNION (SELECT 'field_sodium_value' AS b , field_sodium_value AS a FROM drupal_field_data_field_sodium WHERE entity_id = '#{h['nid']}') UNION (SELECT 'field_fiber_value' AS b, field_fiber_value AS a FROM drupal_field_data_field_fiber WHERE entity_id = '#{h['nid']}')")

    rs2.each_hash do |x|
      puts "testt #{@y[0]}"
      puts x['a']
      if x['a'] == @y[1]
        puts @y[0]
        puts "true"
      end
    end
  end



  con.close

end