require 'rake'
require 'rufus-scheduler'

Rake::Task.clear
Rails.application.load_tasks

scheduler = Rufus::Scheduler::singleton

if ENV['REFRESH_ENABLED']
  scheduler.in '10s' do
    Rake::Task['catalog:refresh'].invoke
    Rake::Task['webhooks:trigger'].invoke
  end

  scheduler.every (ENV['REFRESH_INTERVAL'] || '2h') do
    Rake::Task['catalog:refresh'].invoke
    Rake::Task['webhooks:trigger'].invoke
  end
end