# Room Auction


### Installation

Clone this Repository and run following commands.

Install the dependencies and devDependencies and start the server.

```sh
$ cd project-auction
$ composer update
$ php artisan migrate
$ php artisan serv
```


### Configurations


This app use Laravel Task Scheduling feauture, you only need to add the following Cron entry to your server.

```
$ * * * * * php /path/to/artisan schedule:run >> /dev/null 2>&1
```


### Auction Artisan Command

You can also send to users callback by run 

```sh
$ php artisan auction:sendCallback
```

command. it will be send to all finished active auction bids users callback.
