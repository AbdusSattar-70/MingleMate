Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "https://mingle-mate.vercel.app"

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['access-token', 'expiry', 'token-type', 'Authorization'],
      credentials: true
  end
end
