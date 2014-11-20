ActsAsFerret::define_index(:product,
 :models => {
   Product  => {:fields => [:name]}
 },
 :mysql_fast_batches => false
)
