require_relative '../spec_helper'

describe 'Tests mailer' do
  it 'should send email to required email address with proper content ' do
    # Send the email, then test that it got queued
    email = Mailer.sync_message(
        {:to => 'skhare@ncsu.edu',
         :subject => "Test",
         :body => {
             :obj_name => 'assignment',
             :type => 'submission',
             :location => '1',
             :first_name => 'Shachi',
             :partial_name => 'update'
         }
        }
    ).deliver

    expect(email.from[0]).to eql("expertiza-support@lists.ncsu.edu")
    expect(email.to[0]).to eql('skhare@ncsu.edu')
    expect(email.subject).to eql('Test')
    #assert_equal read_fixture('invite').join, email.body.to_s
  end
end