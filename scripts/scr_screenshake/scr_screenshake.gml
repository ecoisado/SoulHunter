function screenshake(_treme = 1)
{
	if(instance_exists(obj_screenshake))
	{
		with(obj_screenshake)
		{
			if (_treme > treme)
			{
				treme = _treme
			}
		}		
		
	}
}