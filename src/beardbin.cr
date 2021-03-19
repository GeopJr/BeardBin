require "kemal"
require "cryomongo"
require "dotenv"
require "uuix"

module Beardbin
  extend self

  DOTENV = Dotenv.load ".env"
  mongo_client = Mongo::Client.new DOTENV["MONGO_URL"]
  database = mongo_client["beardbin"]
  collection = database["bins"]

  get "/" do |env|
    send_file env, File.join(Kemal.config.public_folder, "index.html")
  end

  # A bin Record
  record Bin, _id : String = UUIX.random, content : String? = "", code : Bool? = false,
    creation_date : Time = Time.utc, custom_password : Bool? = false,
    view_once : Bool? = false, delete_id : String? = Random::Secure.urlsafe_base64(64, padding: false)[0, 64], iv : String? = "" do
    include BSON::Serializable
    include JSON::Serializable
  end

  # POST body classes
  class RetrieveBody
    include JSON::Serializable

    property uuid : String
  end

  class DeleteBody
    include JSON::Serializable

    property uuid : String
    property delete_id : String
  end

  class CreateBody
    include JSON::Serializable

    property content : String
    property custom_password : Bool
    property view_once : Bool
    property code : Bool
    property iv : String
  end

  before_post do |env|
    env.response.content_type = "application/json"
  end

  # POSTS
  post "/delete" do |env|
    begin
      body = DeleteBody.from_json env.request.body.not_nil!
    rescue e
      env.response.status_code = 400
      next {"error" => "#{e.message}"}.to_json
    end
    bin = collection.find_one({_id: body.uuid})
    if bin.to_json == "null" || bin.nil?
      env.response.status_code = 403
      next {"error" => "Couldn't find bin with provided uuid"}.to_json
    end
    bin_hash = bin.to_h

    if bin_hash["delete_id"] != body.delete_id
      env.response.status_code = 403
      next {"error" => "Delete ID is incorrect"}.to_json
    end

    collection.delete_one({_id: bin_hash["_id"], delete_id: body.delete_id})
    next {
      "success" => "Bin got removed",
    }.to_json
  end

  post "/retrieve" do |env|
    begin
      body = RetrieveBody.from_json env.request.body.not_nil!
    rescue e
      env.response.status_code = 400
      next {"error" => "#{e.message}"}.to_json
    end
    bin = collection.find_one({_id: body.uuid})
    if bin.to_json == "null" || bin.nil?
      env.response.status_code = 403
      next {"error" => "Couldn't find bin with provided uuid"}.to_json
    end
    bin_hash = bin.to_h

    collection.delete_one({_id: bin_hash["_id"]}) if bin_hash["view_once"]
    next {
      "content" => "#{bin_hash["content"]}", "code" => bin_hash["code"].as(Bool),
      "custom_password" => bin_hash["custom_password"].as(Bool), "iv" => "#{bin_hash["iv"]}",
    }.to_json
  end

  post "/create" do |env|
    begin
      body = CreateBody.from_json env.request.body.not_nil!
    rescue e
      env.response.status_code = 400
      next {"error" => "#{e.message}"}.to_json
    end

    uuid = UUIX.random
    delete_id = Random::Secure.urlsafe_base64(64, padding: false)[0, 64]

    begin
      collection.insert_one(
        Bin.new(
          _id: uuid, content: body.content, code: body.code,
          custom_password: body.custom_password, view_once: body.view_once,
          iv: body.iv, delete_id: delete_id
        )
      )
      next {"uuid" => "#{uuid}", "delete_id" => "#{delete_id}"}.to_json
    rescue e
      env.response.status_code = 500
      next {"error" => "#{e.message}"}.to_json
    end
  end

  Kemal.run
end
