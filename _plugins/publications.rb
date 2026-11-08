require "jekyll/scholar"

module Jekyll
  class PublicationsTag < Scholar::BibliographyTag
    private

    def sort(entries)
      first_names = Array(config["first_name"])
      last_names = Array(config["last_name"])

      entries.sort_by.with_index do |entry, index|
        author_position = entry[:author]&.tokens&.index do |author|
          author.is_a?(BibTeX::Name) && first_names.include?(author.first) &&
            last_names.include?(author.last.to_s.delete("*∗†‡§¶‖&^"))
        end

        [-entry[:year].to_s.to_i, -entry.month_numeric.to_i, author_position || Float::INFINITY, index]
      end
    end
  end
end

Liquid::Template.register_tag("publications", Jekyll::PublicationsTag)
