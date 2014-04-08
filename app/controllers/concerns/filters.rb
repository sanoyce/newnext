module Filters
  FILTERS = {:states => %w(Active Done Someday Cancelled),
             :futures => %w(include exclude)}
  DEFAULTS = {:states => {'Active'=>'Active'}, :futures => 'exclude', :master => '', :master_id => ''}
  
  
  def filter_all
    session['filters'] = Hash.new unless session['filters']
    @filters = session['filters']
    checkbox_filter :states
    radio_filter :futures
    text_filter :master
    collection_filter :master_id
    text_filter :done_from
    text_filter :done_to
  end

  def collection_filter(filter_name)    
    if params['filters'] && params['filters'][filter_name]
      fltr = params['filters'][filter_name]
      session['filters'][filter_name] = params['filters'][filter_name]
    elsif session['filters'] && session['filters'][filter_name]
      fltr = session['filters'][filter_name]
    else
      fltr = DEFAULTS[filter_name]
    end
    instance_variable_set('@'+filter_name.to_s, fltr)
    @filters[filter_name.to_s] = fltr
  end

  def checkbox_filter(filter_name)
    if params['filters'] && params['filters'][filter_name]
      fltr = params['filters'][filter_name]
      session['filters'][filter_name] = params['filters'][filter_name]
    elsif session['filters'] && session['filters'][filter_name]
      fltr = session['filters'][filter_name]
    else
      fltr = DEFAULTS[filter_name]
    end
    instance_variable_set('@'+filter_name.to_s, fltr)
    @filters[filter_name.to_s] = fltr
  end

  def radio_filter(filter_name)
    if params['filters'] && FILTERS[filter_name].member?(params['filters'][filter_name])
      fltr = params['filters'][filter_name]
      session['filters'][filter_name] = params['filters'][filter_name]
    elsif session['filters'] && FILTERS[filter_name].member?(session['filters'][filter_name])
      fltr = session['filters'][filter_name]
    else
      fltr = DEFAULTS[filter_name]
    end
    instance_variable_set('@'+filter_name.to_s, fltr)
    @filters[filter_name.to_s] = fltr
  end     

  def text_filter(filter_name)
    if params['filters'] && params['filters'][filter_name]
      fltr = params['filters'][filter_name]
      session['filters'][filter_name] = params['filters'][filter_name]
    elsif session['filters'] && session['filters'][filter_name]
      fltr = session['filters'][filter_name]
    else
      fltr = DEFAULTS[filter_name]
    end
    instance_variable_set('@'+filter_name.to_s, fltr)
    @filters[filter_name.to_s] = fltr
  end     
end