class SpreedlySubscription

  if RAILS_ENV == 'production'
    PLANS = [
              { :id => 4110, :max_reports => 5309},
              { :id => 4113, :max_reports => 5310},
              { :id => 4111, :max_reports => 5311}
    ]

  else
    PLANS = [
              { :id => 3351, :max_reports => 5295},
              { :id => 3352, :max_reports => 5296},
              { :id => 3586, :max_reports => 5297}
    ]
  end


end