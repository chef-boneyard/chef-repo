name 'tickr'
description 'configures a tickr server'
run_list(
  'role[wistia-base]',
  'recipe[tickr::default]'
)

default_attributes(
  'tickr' => {
    'max_nodes' => 100,
    'starting_offset' => 4_000_000_000,
    'http_auth_password' => 'k!113rspiN@',
    'deploy_private_key' => <<EOS
-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAv7qOtcqndQpYnssakkX8bNtm2Jo+BCqLM+y9dXrZuHpGvvmz
3MozORpAAaTVhBbAY1eikWe9lT/lq5pPHL4/C2TO0NDHjWLkfAeJbThhl5l+YXcb
2avNpAWtXZqOhC4wSqyBoqpuAwagp3ftaP4HSLxqUVpZoIWgyfGEqnCqo7vsiusj
wyUSxU8M4E8yvfXQCZbmKXDv8ypgRQGLPX0j/BpimKqdIqm024wqI140NvwAUol/
QTvYqeXhL+KAFN/mITFS8B5F2V95+A1aUgJyy4l+8Y1Vw7CRsBuC971sam0KKUI4
/09ZkKyknhNNToBrVQ1BJTjUMUfKLNciiM6/LQIDAQABAoIBAQCYSv66xit3220D
TT9g+viEG065NOOX+Zcy+pSPcbLpRy9U2RGWioJflEtNQvpa/pt5DY5TQ30ixWuQ
gHTg1vlK+psQ4RXxZ6EoJ/Bwcj2K5uCtWKglocMpy1ynInKb6fhwCFC8vfW+r5AD
Fk7dfBKbIxasYkEZMavDXPXNUMsqXGWf86h/JVDwA0c10sG7mUjHru4MQGTEIdz4
V8PBzmELx5vhAMbW2G5sdMO6KfKM6eHEjB7hfz6hqRXTaUdMxw8kYWK/49pW+Kog
jwMIzIO8XlpWWi5zpAKYDEgBIttcWLnejUZzzPhQg0U8HGimDu/q5ftueUTCnNma
uoKT9TX9AoGBAO6C4lqZ4sVCYiHZhINM+VJg5jJs68RuZeMOEEA6vqLoaknew2WQ
/O7NczOXPlV3aFqUj6db6iUb1j1yxlA0rj1jMouPns65KDfJqeHJW7tTSCqaUVip
UwjgYtoV0b/lti2Lxh/WQm0LPb3dbe9LezjfIKLFpM4577oys80TilXTAoGBAM3J
g651hz+Stc3xXZQryNaqEE7jdhASB6eFPQPambS0+FMG+tMcxnZazDi/5kVJp0aG
E8CllxlhiaoopQcpdfibr9WljxZzLV0YOAy25j2f80hE8B/fNU+/DQ1GZ4S6eVms
7PMHOr8Qjn0pupVUHC11zUWNgskhTHcm+NVrPHb/AoGBAIXTYnY7igXsbWtYxQV3
Fx2lyQPaIZ+h4gE4Tt37GCQIDDtOhoxigcjr9guofQ0vZpoMaV4aMJKJv/fSgntW
U72V/zJXb1/GfE5xFKTfelztKbzdwW7h8vk0DcMYIwxtM37ywkPy0GqmuAnkSF7Q
F1+dso4iH4qm71+mO0SCBkiJAoGALslF+wAVg8qjMvNRR0K9IrD/jDACw5yVyOxt
9tZYY9FRM+8+T4kXRglWrQBUJiSct1f8XaxIMikO13TuMDao76DV1UkSwxPkmGnN
NHbQ2ennseKahWSGBl91ZDNBjdenh0/df1OBc7cb7jDyjsjUrzE9PjbyKTA85koi
AMOkt5kCgYEA37JDb4aCXM7XH9y285ILZOva0h3RTufjuoKhJIll+QgMaBLNnLTR
F6ZpeqWR1UU5PcP7E8Y517Ff51ndFKQzCFT55vEyTg0e28FAig2BcQyUbC69Iq3V
2cJF5vGJCF7v4oOSak2banNvwXp2Sq0T8BvRRhPo16KvZUWh6gSxIA8=
-----END RSA PRIVATE KEY-----
EOS
  }
)
