class AddConfigurationOptionsForDigitalMediaCenterApi < ActiveRecord::Migration
  def self.up
    configuration = Configuration.find_by_code!('default')

    configuration.options.create([
      {
        name: 'Digital Media Center Host',
        code: 'digital_media_center/host',
        value: configatron.dmc.host
      }, {
        name: 'Digital Media Center Token',
        code: 'digital_media_center/token',
        value: configatron.dmc.user_token
      }
    ])
  end

  def self.down
    raise IrreversibleMigration
  end
end
