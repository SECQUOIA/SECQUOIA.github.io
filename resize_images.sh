#!/bin/bash

# Define image directories
IMAGE_DIR="assets/images"
OUTPUT_DIR="${IMAGE_DIR}/optimized"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Check for required tools
command -v convert >/dev/null 2>&1 || { echo "ImageMagick (convert) is required. Install with: sudo apt-get install imagemagick"; exit 1; }
command -v jpegoptim >/dev/null 2>&1 || { echo "jpegoptim is required. Install with: sudo apt-get install jpegoptim"; exit 1; }
command -v optipng >/dev/null 2>&1 || { echo "optipng is required. Install with: sudo apt-get install optipng"; exit 1; }
command -v cwebp >/dev/null 2>&1 || { echo "WebP tools are required. Install with: sudo apt-get install webp"; exit 1; }

# Image size settings
MAX_WIDTH=1920          # General images
BANNER_WIDTH=2560       # Banner images
PROFILE_WIDTH=600       # Profile/member photos
ICON_WIDTH=300          # Icons and small images

# Function to process images
process_image() {
    local input_file="$1"
    
    # Get the relative path from IMAGE_DIR
    local rel_path=${input_file#"$IMAGE_DIR/"}
    local dir_path=$(dirname "$rel_path")
    local filename=$(basename "$input_file")
    local extension="${filename##*.}"
    local basename="${filename%.*}"
    
    # Create output directory structure if it doesn't exist
    if [ "$dir_path" != "." ]; then
        mkdir -p "$OUTPUT_DIR/$dir_path"
        output_file="$OUTPUT_DIR/$dir_path/$basename.$extension"
        webp_file="$OUTPUT_DIR/$dir_path/$basename.webp"
    else
        output_file="$OUTPUT_DIR/$basename.$extension"
        webp_file="$OUTPUT_DIR/$basename.webp"
    fi
    
    echo "Processing: $rel_path"
    
    # Determine appropriate width based on image path and name
    if [[ "$input_file" == *"/members/"* ]]; then
        # Member profile pictures
        resize_width=$PROFILE_WIDTH
        echo "  Detected as member profile image"
    elif [[ "$filename" == *"banner"* || "$filename" == *"hero"* || "$filename" == *"header"* ]]; then
        # Banner images
        resize_width=$BANNER_WIDTH
        echo "  Detected as banner image"
    elif [[ "$filename" == *"icon"* || "$filename" == *"logo"* || "$input_file" == *"/icons/"* ]]; then
        # Icons and logos
        resize_width=$ICON_WIDTH
        echo "  Detected as icon/logo"
    else
        # General images
        resize_width=$MAX_WIDTH
        echo "  Processing as standard image"
    fi
    
    # Get current dimensions
    dimensions=$(identify -format "%wx%h" "$input_file")
    width=$(echo $dimensions | cut -d'x' -f1)
    
    # Only resize if the image is wider than our target
    if [ "$width" -gt "$resize_width" ]; then
        echo "  Resizing to ${resize_width}px width"
        convert "$input_file" -resize "${resize_width}x" -quality 85% "$output_file"
        if [ $? -ne 0 ]; then
            echo "Error: Failed to resize image $input_file" >&2
            exit 1
        fi
    else
        echo "  Image is already ${width}px width, copying"
        cp "$input_file" "$output_file"
    fi
    
    # Optimize based on file type
    if [[ "$extension" == "jpg" || "$extension" == "jpeg" ]]; then
        echo "  Optimizing JPEG"
        jpegoptim --max=80 "$output_file"
    elif [[ "$extension" == "png" ]]; then
        echo "  Optimizing PNG"
        optipng -o3 "$output_file"
    fi
    
    # Create WebP version
    echo "  Creating WebP version"
    cwebp -q 80 "$output_file" -o "$webp_file"
    if [ $? -ne 0 ]; then
        echo "  Error: Failed to create WebP version for $rel_path" >&2
        return 1
    fi
    
    echo "  Done: $rel_path ($(du -h "$output_file" | cut -f1)) and ${basename}.webp ($(du -h "$webp_file" | cut -f1))"
    echo
}

# Create mobile versions of banner images
create_mobile_version() {
    local input_file="$1"
    
    # Get the relative path from IMAGE_DIR
    local rel_path=${input_file#"$IMAGE_DIR/"}
    local dir_path=$(dirname "$rel_path")
    local filename=$(basename "$input_file")
    
    # Only process likely banner images
    if [[ "$filename" == *"banner"* || "$filename" == *"hero"* || "$filename" == *"header"* ]]; then
        local extension="${filename##*.}"
        local basename="${filename%.*}"
        
        if [ "$dir_path" != "." ]; then
            mkdir -p "$OUTPUT_DIR/$dir_path"
            mobile_file="$OUTPUT_DIR/$dir_path/$basename-mobile.$extension"
            mobile_webp="$OUTPUT_DIR/$dir_path/$basename-mobile.webp"
        else
            mobile_file="$OUTPUT_DIR/$basename-mobile.$extension"
            mobile_webp="$OUTPUT_DIR/$basename-mobile.webp"
        fi
        
        echo "Creating mobile version for: $rel_path"
        
        # Create smaller version for mobile (768px width is common for mobile)
        convert "$input_file" -resize "768x" -quality 80% "$mobile_file"
        
        # Optimize
        if [[ "$extension" == "jpg" || "$extension" == "jpeg" ]]; then
            jpegoptim --max=75 "$mobile_file"
        elif [[ "$extension" == "png" ]]; then
            optipng -o3 "$mobile_file"
        fi
        
        # Create WebP version
        cwebp -q 75 "$mobile_file" -o "$mobile_webp"
        
        echo "  Done: ${basename}-mobile.$extension ($(du -h "$mobile_file" | cut -f1)) and ${basename}-mobile.webp ($(du -h "$mobile_webp" | cut -f1))"
        echo
    fi
}

# Process all images, recursively through all subdirectories
echo "Processing all images recursively..."
find "$IMAGE_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -not -path "$OUTPUT_DIR/*" | while read img; do
    process_image "$img"
    create_mobile_version "$img"
done

echo "All images have been processed and saved to: $OUTPUT_DIR"

# Provide a summary of space savings
echo "Calculating size comparison..."
original_size=$(du -sh "$IMAGE_DIR" --exclude="$OUTPUT_DIR" | cut -f1)
optimized_size=$(du -sh "$OUTPUT_DIR" | cut -f1)
echo "Original images directory size: $original_size"
echo "Optimized images directory size: $optimized_size"

echo ""
echo "If you are satisfied with the optimized images, you can replace the originals with:"
echo "--------------------------------------------------------"
echo "# WARNING: This will replace your original images with the optimized ones"
echo "# Make sure to back up your images first if needed"
echo ""
echo "find \"$OUTPUT_DIR\" -type f -not -path \"*/\.*\" | while read file; do"
echo "  dest_file=\"\${file/$OUTPUT_DIR/$IMAGE_DIR}\""
echo "  dest_dir=\$(dirname \"\$dest_file\")"
echo "  mkdir -p \"\$dest_dir\""
echo "  cp \"\$file\" \"\$dest_file\""
echo "done"
echo ""
echo "# Remove the optimized directory after copying"
echo "rm -rf \"$OUTPUT_DIR\""
echo "--------------------------------------------------------"