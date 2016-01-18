use Mix.Config

config :arc,
  bucket: "",
  virtual_host: false,
  arc_storage: Arc.Storage.S3

config :ex_aws,
  access_key_id: "",
  secret_access_key: ""
