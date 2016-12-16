<?php

namespace App\Console;

use App\Auction;

use  \GuzzleHttp\Client;
use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    /**
     * The Artisan commands provided by your application.
     *
     * @var array
     */
    protected $commands = [
        //
    ];

    /**
     * Define the application's command schedule.
     *
     * @param  \Illuminate\Console\Scheduling\Schedule  $schedule
     * @return void
     */
    protected function schedule(Schedule $schedule)
    {
        /**
         * Get all active auction every 10minutes
         * for High scale apps we could cache all 
         * active autction and recall it from cache
         */
        $schedule->call(function () {
            $activeActions = Auction::active();

            foreach ($activeActions as $auction) {

                $this->prepareToCallback($auction);
                $auction->deactive();
            }

        })->everyTenMinutes();
    }

    /**
     * Register the Closure based commands for the application.
     *
     * @return void
     */
    protected function commands()
    {
        require base_path('routes/console.php');
    }


    /**
     * Prepare Auction Object to post 
     * users callback
     * @param  Object $auction Auction
     */
    protected function prepareToCallback($auction)
    {
        $winner = $auction->bids->last();
        $this->submitWinnerCallback($winner, $auction);

        // create array of loser and remove
        // duplicated bids
        $losers = $auction->bids
                            ->unique('user_id')
                            ->groupBy('user_id')
                            ->pop($winner->id)
                            ->flatten();

        // send to losers callback
        $this->submitLosersCallback($losers, $auction);
    }  


    /**
     * Submit response to winner callback URL
     * @param  Object $winner winner object
     * @param  object $auction auction objcet
     */
    protected function submitWinnerCallback($winner, $auction)
    {
        if (!empty($winner->user->callback)){
            $client = new \GuzzleHttp\Client();
            $client->request('POST', $winner->callback, 
                [
                'json' => [
                'msg' => "Congratulation! Your $winner->price bid was won the $auction->name!" ]
                ]);
        }

    }

    /**
     * Submit to Losers callback urls
     * @param  Array $losers  losers array
     * @param  object $auction auction objcet
     */
    protected function submitLosersCallback($losers, $auction)
    {
        foreach ($losers as $loser) {
            if (!empty($loser->user->callback)){
                $client = new \GuzzleHttp\Client();
                $client->request('POST', $loser->callback, 
                    [
                    'json' => [
                    'msg' => " Sorry Your $loser->price bid was not win the $auction->name!" ]
                    ]);
            }
        }
    }
}
