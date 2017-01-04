# Room Auction

### Server Requirements
The Laravel framework has a few system requirements. Of course, all of these requirements are satisfied by the Laravel Homestead virtual machine, so it's highly recommended that you use Homestead as your local Laravel development environment.

However, if you are not using Homestead, you will need to make sure your server meets the following requirements:

* PHP >= 5.6.4
* OpenSSL PHP Extension
* PDO PHP Extension
* Mbstring PHP Extension
* Tokenizer PHP Extension
* XML PHP Extension

### Installation

Clone this Repository and run following commands.

Install the dependencies and devDependencies and start the server.

```sh
$ cd project-auction
$ composer update
```

rename `.env.example` file to `.env` 
### Edit Enviorment file

The next thing you should do after installing Laravel is set your application key to a random string. If you installed Laravel via Composer or the Laravel installer, this key has already been set for you by the `php artisan key:generate` command.

Typically, this string should be 32 characters long. The key can be set in the .env environment file. If you have not renamed the `.env.example` file to `.env`, you should do that now. If the application key is not set, your user sessions and other encrypted data will not be secure!
```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=database
DB_USERNAME=user
DB_PASSWORD=pass
```
### Directory Permissions

After installing Laravel, you may need to configure some permissions. Directories within the `storage` and the `bootstrap/cache` directories should be writable by your web server or Laravel will not run.


### Configurations


This app use Laravel Task Scheduling feauture, you only need to add the following Cron entry to your server.

```sh
$ crontab -e
```
in opened crontab add this line:

` * * * * * php /path/to/artisan schedule:run >> /dev/null 2>&1`


At the end run these command to finish installation:
```
$ php artisan migrate
$ php artisan serv
```

### Auction Artisan Command

You can also send to users callback by run 

```sh
$ php artisan auction:sendCallback
```

command. it will be send to all finished active auction bids users callback.

### App Test (TDD)

To run TDD, in your app location run this command:

```sh
$ vendor/bin/phpunit
```


