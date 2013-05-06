root = File.absolute_path(File.dirname(__FILE__))
 
file_cache_path root
data_bag_path root + '/data_bags'
encrypted_data_bag_secret root + '/data_bag_key'
cookbook_path root + '/cookbooks', root + '/site-cookbooks'
role_path root + '/roles'