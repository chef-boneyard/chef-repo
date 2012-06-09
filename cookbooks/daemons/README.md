Utility cookbook to daemonize any script using runit

Depends on runit.

## Example configuration
  "daemons": {
           "script_one": {
                         "command": "python /path/to/some/script -foo -bar",
           },
           "script_two": {
                         "command": "ruby /path/to/something/else",
           }
  }

For each daemon, it creates a runit config based on the sv-daemon-run.erb template in templates directory.
