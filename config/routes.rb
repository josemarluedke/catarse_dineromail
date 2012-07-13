CatarseDineromail::Engine.routes.draw do
  get "payment/dineromail/pay/:id", to: "payment::dineromail#pay"
end
