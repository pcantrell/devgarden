class MakeGithubUsernamesLowerCase < ActiveRecord::Migration[5.0]
  def up
    %w(email github_user).each do |lowercase_prop|
      execute "update people set #{lowercase_prop} = lower(#{lowercase_prop})"
    end
  end

  def down
  end
end
