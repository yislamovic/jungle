namespace :images do
  desc "Generate thumbnails for existing product images"
  task generate_thumbnails: :environment do
    require 'rmagick'
    
    # Directory containing the uploads
    uploads_dir = Rails.root.join('public', 'uploads', 'product', 'image')
    
    # Process each product directory
    (1..24).each do |product_id|
      product_dir = uploads_dir.join(product_id.to_s)
      
      # Find the original image file
      original_file = Dir.glob(product_dir.join('*.jpg')).first
      
      if original_file
        puts "Processing product #{product_id}: #{File.basename(original_file)}"
        
        begin
          # Read the original image
          img = Magick::Image.read(original_file).first
          
          # Generate thumb version (300x300)
          thumb = img.resize_to_fit(300, 300)
          thumb_path = product_dir.join("thumb_#{File.basename(original_file)}")
          thumb.write(thumb_path.to_s)
          puts "  Created thumbnail: #{thumb_path}"
          
          # Generate tiny version (100x100) 
          tiny = img.resize_to_fit(100, 100)
          tiny_path = product_dir.join("tiny_#{File.basename(original_file)}")
          tiny.write(tiny_path.to_s)
          puts "  Created tiny: #{tiny_path}"
          
          # Clean up memory
          img.destroy!
          thumb.destroy!
          tiny.destroy!
          
        rescue => e
          puts "Error processing #{original_file}: #{e.message}"
        end
      else
        puts "No image found for product #{product_id}"
      end
    end
    
    puts "Thumbnail generation complete!"
  end
end