<?php

namespace App;

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;

class User extends Authenticatable
{
    use Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'name', 'email', 'password', 'callback'
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password', 'remember_token',
    ];


    /**
    * Get the User Auctions.
    */
    public function auctions()
    {
        return $this->hasMany('App\Auction');
    }


    /**
    * Get the User Bids.
    */
    public function bids()
    {
        return $this->hasMany('App\Bid');
    }
}
