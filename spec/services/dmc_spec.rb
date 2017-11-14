require "spec_helper"

describe Services::Dmc do
  before(:all) do
    user = User.new
    @service = Services::Dmc.new(as: user)
  end

  it "returns galleries" do
    VCR.use_cassette('dmc/galleries') do
      galleries = @service.galleries
      expect(galleries.size).to eq 2
      gallery = galleries.first
      expect(gallery.id).to eq 3
      expect(gallery.name).to eq "Example User's gallery"
    end
  end

  it "returns folders" do
    VCR.use_cassette('dmc/folders') do
      folders = @service.folders(gallery_id: 3)
      expect(folders.size).to eq 1
      folder = folders.first
      expect(folder.id).to eq 3
      expect(folder.name).to eq "default"
    end
  end

  it "returns assets" do
    VCR.use_cassette('dmc/assets') do
      results = @service.assets(gallery_id: 3, folder_id: 3)
      expect(results.total_count).to eq 4
      assets = results.collection
      expect(assets.size).to eq 4
      asset = assets.first
      expect(asset.title).to eq 'Rainbow'
      expect(asset.description).to be_present
      expect(asset.thumb_url).to be_present
      expect(asset.medium_url).to be_present
    end
  end

  it "returns paginated assets" do
    VCR.use_cassette('dmc/paginated_assets') do
      results = @service.assets(gallery_id: 3, folder_id: 3, page: 2, per: 1)
      expect(results.total_count).to eq 4
      expect(results.collection.size).to eq 1
    end
  end

  it "handles errors" do
    VCR.use_cassette('dmc/unexisting_gallery_assets') do
      expect do
        response = @service.folders(gallery_id: 'unknown_id')
      end.to raise_error(Errors::Dmc::RemoteError)
    end
  end

  it "finds galleries" do
    VCR.use_cassette('dmc/galleries') do
      gallery = @service.find_gallery("3")
      expect(gallery).to be_present
      expect(gallery.id).to eq 3
      expect(gallery.name).to eq "Example User's gallery"
    end
  end

  it "handles not found gallery" do
    VCR.use_cassette('dmc/galleries') do
      expect do
        @service.find_gallery('unknown_id')
      end.to raise_error(Errors::Dmc::NotFound)
    end
  end

  it "returns asset manifest" do
    VCR.use_cassette('dmc/asset_manifest') do
      manifest = @service.asset_manifest(
        gallery_id: 3,
        folder_id:  3,
        asset_id:   9
      )
      expect(manifest).to be_present
    end
  end
end