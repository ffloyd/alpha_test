$(document).on 'turbolinks:load', ->
  $('[data-role=calculator]').each (index, el) ->
    $el = $(el)
    $input = $el.find('input[type=number]')

    $optimisticIncomeOutput = $el.find('dd[data-output=optimistic_income]')
    $expectedIncomeOutput   = $el.find('dd[data-output=expected_income]')

    optimisticRate  = $el.data().optimisticRate
    expectedRate    = $el.data().expectedRate
    duration        = $el.data().duration

    $input.on 'input', ->
      sum = parseFloat $input.val()

      if isNaN(sum)
        optimisticIncome = 0
        expectedIncome   = 0
      else
        optimisticIncome  = sum * optimisticRate * (duration / 12)
        expectedIncome    = sum * expectedRate * (duration / 12)

      $optimisticIncomeOutput.text(optimisticIncome.toFixed(4))
      $expectedIncomeOutput.text(expectedIncome.toFixed(4))
