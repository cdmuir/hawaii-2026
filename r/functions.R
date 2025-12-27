read_raw_li600 = function(raw_data_dir) {

  assert_directory_exists(raw_data_dir)
  
  all_files = list.files(raw_data_dir, recursive = TRUE, full.names = TRUE)
  
  raw_file_pattern = "stomata-leafang_CDM"
  
  all_files[str_detect(all_files, raw_file_pattern) &
              str_detect(all_files, ".csv$")] |>
    map(
      read_csv,
      skip = 1,
      name_repair = "minimal",
      col_select = all_of(li600_headers),
      col_types = "c",
      show_col_types = FALSE
    )
  
  raw_data = all_files[which(str_detect(all_files, raw_file_pattern) &
                               str_detect(all_files, ".csv$"))] |>
    map(
      read_csv,
      skip = 1,
      name_repair = "minimal",
      col_select = all_of(li600_headers),
      col_types = "c",
      show_col_types = FALSE
    ) |>
    map_dfr(\(.x) {
      ret = .x |>
        mutate(across(everything(), as.character))
      ret[2:nrow(ret), ]
    })
  
  raw_data
  
}

# for testing
# data = raw_li600
# corrections = li600_corrections

apply_li600_corrections = function(data, corrections) {
  data1 = data |>
    separate_wider_delim(Date, names = c("YYYY", "MM", "DD"), delim = "-") |>
    separate_wider_delim(Time, names = c("hh", "mm", "ss"), delim = ":")
  
  unmatched = anti_join(corrections, data1, by = join_by(hh, mm, ss, YYYY, MM, DD, remark))
  
  # Test: are there any unmatched rows?
  if (nrow(unmatched) == 0) {
    message("✅ All rows in `corrections` have a match in `data2`.")
  } else {
    message("❌ Some rows in `corrections` do NOT have a match in `data2.")
    print(unmatched)
  }
  
  
  left_join(data1, corrections, by = join_by(hh, mm, ss, YYYY, MM, DD, remark)) |>
    filter(action %in% c(NA, "change")) |>
    mutate(
      surface = case_when(action == "change" ~ surface, is.na(action) ~ remark),
      plant_number = case_when(
        action == "change" ~ plant_number_correct,
        is.na(action) ~ plant_number
      )
    ) |>
    select(-action, -plant_number_correct) |>
    unite("Date",
          c("YYYY", "MM", "DD"),
          sep = "-",
          remove = TRUE) |>
    unite("Time",
          c("hh", "mm", "ss"),
          sep = ":",
          remove = TRUE)
  
  
}

make_hemisphere = function(x) {
  assert_file_exists(x)
  
  # Step 1: Read the image
  img = image_read(x)
  
  # Step 2: Get image dimensions
  info = image_info(img)
  width = info$width
  height = info$height
  
  # Step 3: Crop to top half
  img_polar = img |>
    image_crop(geometry = geometry_area(width, height / 2, 0, 0)) |>
    # Step 4: Resize to square (scale top half to a square)
    image_resize(geometry_size_pixels(
      width = width,
      height = width,
      preserve_aspect = FALSE
    )) |>
    # Step 5: Remap to polar projection
    image_distort(distortion = "Polar",
                  coordinates = 0,
                  bestfit = TRUE)
  
  # Step 6: Create a circular alpha mask (white inside circle, black outside)
  polar_width = image_info(img_polar)$width
  mask = image_blank(width = polar_width,
                     height = polar_width,
                     color = "black") |>
    image_draw()
  symbols(
    x = polar_width / 2,
    y = polar_width / 2,
    circles = polar_width / 2,
    inches = FALSE,
    add = TRUE,
    fg = "black",
    bg = "white"
  )
  dev.off()
  
  # Step 7: Add alpha channel to image using the mask
  image_composite(image = img_polar,
                  composite_image = mask,
                  operator = "Multiply")
  
}
