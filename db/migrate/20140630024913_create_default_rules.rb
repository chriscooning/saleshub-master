class CreateDefaultRules < ActiveRecord::Migration
  def self.up
    Operand.create(
      [
        { presentation: 'Message', code: 'message' },
        { presentation: 'Survey', code: 'survey' },
        { presentation: 'News', code: 'news' },
        { presentation: 'Briefing', code: 'briefing' },
        { presentation: 'What\'s Up', code: 'whats_up' }
      ]
    )
    Operation.create(
      [
        { presentation: 'Create', code: 'create' },
        { presentation: 'Read', code: 'read' },
        { presentation: 'Update', code: 'update' },
        { presentation: 'Delete', code: 'delete' },
      ]
    )
    Operand.all.each do |operand|
      Operation.all.each do |operation|
        [true, false].each do |is_allow|
          [true, false].each do |is_global|
            Rule.create(
              is_allow: is_allow,
              is_global: is_global,
              operand_id: operand.id,
              operation_id: operation.id
            )
          end
        end
      end
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
