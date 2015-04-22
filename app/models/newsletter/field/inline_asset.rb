=begin rdoc
Author::    Chris Hauboldt (mailto:biz@lnstar.com)
Copyright:: 2009 Lone Star Internet Inc.

InlineAsset is a Newsletter::Field that allows either a url or an uploaded asset(image/document) to be used in a Newsletter.

=end

module Newsletter
  class Field::InlineAsset < Field
    has_many :assets, :foreign_key => :field_id, 
      :class_name => 'Newsletter::Asset'

    # overridden from main class to choose between a Newsletter::Asset or a given URL
    def value_for_piece(piece)
      Value.new(:url => url_for_piece(piece), :text => get_value(piece,:text), :asset => asset(piece))
    end

    # overridden from main class to choose between a Newsletter::Asset or a given URL
    def set_value_for_piece(piece,params)
      if params[:url]
        unless url_for_piece(piece).eql?(params[:url])
          asset(piece).destroy if asset(piece)
          set_value(piece,:url,params[:url])
        end
      end
      set_value(piece,:text,params[:text]) if params[:text]
      if params[:uploaded_data]
        asset = asset(piece)
        if asset && params[:asset_id] == asset.id.to_s
          asset.image = params[:uploaded_data]
        else
          asset = assets.build
          piece.assets << asset
          asset.image = params[:uploaded_data]
        end
        asset.save
      end
    end

    # uniformly get URL so we can know whether it has been modified and delete 
    # any asset uploaded
    def url_for_piece(piece)
      return "#{::Newsletter.site_url}/#{asset(piece).public_filename}" unless asset(piece).try(:public_filename).nil?
      get_value(piece,:url)
    end

    def asset(piece)
      assets.by_piece(piece).first
    end

    # create nicer accessors for use in design since this is more than one value, unlike other
    # fields
    class Value
      attr_accessor :url, :text, :asset, :asset_id
      def is_image?
        if asset.present?
          asset.is_image?
        else
          is_image_by_extension?
        end
      end

      def is_image_by_extension?
        extension = File.extname(url).gsub(/^\./,'')
        [ 'bmp', 'cod', 'gif', 'ief', 'jpe', 'jpeg', 'jpg', 'png',
          'jfif', 'svg', 'tif', 'tiff'
        ].include?(extension.downcase)
      end

      def initialize(params)
        @url = params[:url]
        @text = params[:text]
        @asset = params[:asset]
        @asset_id = @asset.nil? ? nil : @asset.id
      end
    end

  end
end
