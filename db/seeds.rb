begin
    user = User.new
    user.email = 'test@test.com'
    user.first_name = 'Jae'
    user.last_name = 'Lee'
    user.username = 'admin'
    user.password = 'asdfasdf'
    user.password_confirmation = user.password
    user.role = 'admin'
    user.provider = 'email'
    user.avatar_url = '/vendor/honeybadger/img/avatar.jpg'
    user.save
rescue Exception => e
end

begin
    post = Post.new
    post.user_id = 1
    post.title = "Why I created Honeybadger"
    post.teaser = "One day I said to myself enough is enough. I have been turmoiled by lack of quality minimal frameworks to get me started on new projects. And thus ..."
    post.content = "I wanted a simple and lightweight blogging / CMS framework for Ruby and no matter how much I looked, I just could not find one. "
    post.created_at = Time.now
    post.save
rescue Exception => e
end

begin
    company = Company.new
    company.company = "Uber"
    company.user_id = 1
    company.industry = "taxi"
    company.logo_url = "/uploads/uber.jpeg"
    company.promo_text = "$20 off free ride"
    company.title = "The largest taxi service"
    company.description = "Uber is one of the fastest growing taxi company in the world. With Uber, you can call a taxi within minutes and they will come pick you right up."
    company.commission_type = "dollar"
    company.commission_amount = "5"
    company.status = "soon"
    company.save

    for i in 1..30
    code = Code.new
    code.company_id = company.id
    code.code = 'UBER' + i.to_s
    code.save
    end

rescue Exception => e
end

begin
    company = Company.new
    company.company = "Lyft"
    company.user_id = 1
    company.industry = "taxi"
    company.logo_url = "/uploads/lyft.jpeg"
    company.promo_text = "$50 off free ride"
    company.title = "The 2nd largest taxi service"
    company.description = "Lyft is second the fastest growing taxi company in the world. Just like Uber, you can call a taxi within minutes and they will come pick you right up."
    company.commission_type = "dollar"
    company.commission_amount = "3"
    company.status = "soon"
    company.save

    for i in 1..30
    code = Code.new
    code.company_id = company.id
    code.code = 'LYFT' + i.to_s
    code.save
    end
rescue Exception => e
end

begin
    company = Company.new
    company.company = "FastFollowerz"
    company.user_id = 1
    company.industry = "Social Media"
    company.logo_url = "/uploads/FF_logo_large.png"
    company.promo_text = "$10 off all purchases"
    company.title = "Buy social media followers"
    company.description = "Fast Followerz is one of the largest and the most reputable service to buy followers for your social media. They cater to most social medias, such as Facebook, Twitter, and Instagram."
    company.commission_type = "dollar"
    company.commission_amount = "20"
    company.markett_amount = "5"
    company.status = "active"
    company.save

    # for i in 1..30
    # code = Code.new
    # code.company_id = company.id
    # code.code = 'LYFT' + i.to_s
    # code.save
    # end
rescue Exception => e
end

begin
    Setting.create(
        :name => 'site_title', :value => 'Markett | Making money'
    )
    Setting.create(
        :name => 'site_host', :value => 'markett.io'
    )
    Setting.create(
        :name => 'open_slots', :value => 3
    )
rescue Exception => e
end
