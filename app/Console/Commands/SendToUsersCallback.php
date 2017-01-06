<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use \GuzzleHttp\Client;

use App\Auction;

class SendToUsersCallback extends Command
{

    /**
     * Winner
     * @var Object
     */
    protected $winner;

    /**
     * losers
     * @var Object
     */
    protected $losers;

    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'auction:sendCallback';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Send response to users who have bids';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {

        /**
         * Get all active auction 
         * for Higher scale apps we could cache all 
         * active autction and get it from cache
         */
        
        $this->info('Getting all Available Auctions');

        $activeAuctions = Auction::active()->finished()->get();

        foreach ($activeAuctions as $auction) {
             if ($auction->minBidsAvailable()) {
                $this->prepareToCallback($auction);
            }else{

                $this->losers = $auction->bids
                                    ->unique('user_id')
                                    ->groupBy('user_id')
                                    ->flatten();

                $this->submitLosersCallback($auction);

            }
            $auction->deactive();
        }
        $this->info('All job is done!');
    }   


    /**
     * Prepare Auction Object to post 
     * users callback
     * @param  Object $auction Auction
     */
    protected function prepareToCallback($auction)
    {
        $this->winner = $auction->bids->last();
        $this->submitWinnerCallback($auction);

        // create array of loser and remove
        // duplicated bids
        $this->losers = $auction->bids
                            ->unique('user_id')
                            ->groupBy('user_id')
                            ->pop($this->winner->id)
                            ->flatten();

        // send to losers callback
        $this->submitLosersCallback($auction);
    }  


    /**
     * Submit response to winner callback URL
     * @param  Object $winner winner object
     * @param  object $auction auction objcet
     */
    protected function submitWinnerCallback($auction)
    {
        if (!is_null($this->winner->user->callback)){
            $price = $this->winner->price;
            $client = new \GuzzleHttp\Client();
            $client->request('POST', $this->winner->user->callback, 
                [
                'json' => [
                'msg' => "Congratulation! Your $price bid was won the $auction->name!" ]
                ]);
        }

    }

    /**
     * Submit to Losers callback urls
     * @param  Array $losers  losers array
     * @param  object $auction auction objcet
     */
    protected function submitLosersCallback($auction)
    {
        foreach ($this->losers as $loser) {
            if (!is_null($loser->user->callback)){
                $client = new \GuzzleHttp\Client();
                $client->request('POST', $loser->user->callback, 
                    [
                    'json' => [
                    'msg' => " Sorry Your $loser->price bid was not win the $auction->name!" ]
                    ]);
            }
        }
    }
}
