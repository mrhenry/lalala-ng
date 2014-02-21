# Haraway

## How to use

1. Create initializer (config/initializers/haraway.rb)
2. Add "haraway_metadata" column to the necessary tables (type = "text")
3. In the model:  
`has_many_assets :asset_association_name, :profile`
`attr_accessible :asset_association_name`


## To do

- Include actual Haraway gem (not the local repo)
- Insert image overlay (markdown)


## Bugs

- When selecting a language, which is not the default, and then
  creating a new article, produces a validation error for the "title".


## Insert image

Which images should be displayed: (dropdown menu options)

- Media related to this "model"
- All media
