let
  surt = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCMtkqE7aug1QasRhisRMqqwn+HHuuws/suTtPHZXNJVKrZ1TdCBVozVS3WbaxbaC54hyOSe01H4H175re6SLMgoX+E3etbUJL+l52ZejgtGed2NXQqK3JXtsioCS4HrPZaAbeyWMozAKt97YXrzcCKdCH3TfVHNtpOga3ZeJdN3qQIiiZzFeOG0I2We7KZIIG5C+6VibYluS5IXGEHVKvarGk+8JX5QRwH0Vun8kpeImnlhXy/JDo9IvGkR079b53qEv/cjwh3OXDTqKUN5K+p5VmSvCwbqncozgIajeeaO4/1dj5oQgYkEPhkfgZaE8sHpTPc4x/eJIfLBVDjIc/o9kheKFg6mVYYxc6tJsgyokS1j7N1cYQEjPRTmnTZVqW6zzG4/lHT3TGU/s5ofy30ZgCsSE2Abf3H++Bo82cxXkr7uAO2PTx6JH874inYK4zR2QHnYVoPFRa8c3GG+R/gFFA54I+OtPZvyCwg1wr3mv21nI/HNnk9Q0XkjKVRhOE= surt@gimle";
  surt-sshd = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5hhkty3d27nHBAIEpuuwcPS0Xw6JTSyTWs7o4CcCD49AL5Q52HV76MaU7ceNgOocLNnr6vQHCD7UqZm735MroIRKVgSr/x/Zr4uwgCTILvgjCFtIkopc4lkEFvKz9qqEGkGmbyOyGQJSUWtiG0Vi1qgAu1PfDFHsS62zAKwtaI+6B59Rgewzu55fSSDDeenxsMzEgqFiFzfaWCsJuaAxVWXIuHNNDFvj9hDMn6brCZknuAG9SxH4/A3bsfU7lFvDPfrWiTAWw6pM1YopMkj+bmJ2SzPcieSmO1H5nEOQNVC4mMWDZ+50fSgtgI1PLVGUeUzTw55dFWJRBecO7vXD/7+tdMGSPyNTyh9c67fzaUY74i5HA8eAQ7OpiNK1iQSQQeBCXbjZFim888HIrromlML/fdn2lMerLq/N/Zaa6YMNALQ4zDgy0gb608mlBGY/S4AkeqfENOw4/r351ziWwG8heq/+k2OfNNKmPQbA3nQpRcs+9wtQyE74bZvi+RzMUgnEY1xdSWUVNJcidapzWsPSoqk2Mk63xq/jF6KkGElYKS/N87vXnJzljW8NM1gosd3t+pWj/EntcoK1fmevmxaF7BIUEiYBYeAWoO7GlH3RNiXVIniGBw498kqsuSJsG1p0rrtdvws+lGgEqeHznzn7XhHVya+/pEwukP3afRw== root@gimle";
in
{
  "deluge-pass.age".publicKeys = [ surt surt-sshd ];
  "wireguard-key.age".publicKeys = [ surt surt-sshd ];
  "matrix-synapse-secret.age".publicKeys = [ surt ];
}
