class CountdownsController < ApplicationController
  #カウントダウン
    def show
      @countdown = Countdown.last
    end
  end